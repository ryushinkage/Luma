/**
 * API-клиент Sleep Analytics (Luma.Api).
 *
 * Покрывает ВСЕ существующие эндпоинты бэкенда:
 *   POST   /api/auth/register
 *   POST   /api/auth/login
 *   POST   /api/SleepRecords
 *   GET    /api/SleepRecords/user/{userId}
 *   POST   /api/UserProfiles
 *   GET    /api/v1/entries
 *   POST   /api/v1/entries
 *   GET    /api/v1/entries/{id}
 *   PUT    /api/v1/entries/{id}
 *   DELETE /api/v1/entries/{id}
 *   GET    /api/v1/users/count
 *
 * Адрес бэкенда берётся из .env: VITE_API_BASE_URL
 *
 * JWT хранится в памяти модуля (не в localStorage — по правилам артефактов
 * и из соображений безопасности). При перезагрузке страницы токен теряется;
 * если нужна персистентность — см. setToken/getToken.
 */

const API_BASE =
  import.meta.env.VITE_API_BASE_URL ??
  "https://natural-wonder-production-3777.up.railway.app";

let authToken = null;

export function setToken(token) {
  authToken = token;
}

export function getToken() {
  return authToken;
}

export function clearToken() {
  authToken = null;
}

/** Достаёт userId из JWT (claim NameIdentifier) без внешних библиотек. */
export function getUserIdFromToken(token = authToken) {
  if (!token) return null;
  try {
    const payload = JSON.parse(atob(token.split(".")[1]));
    return (
      payload.nameid ||
      payload.sub ||
      payload[
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"
      ] ||
      null
    );
  } catch {
    return null;
  }
}

/** Достаёт роль из JWT (claim role). Возвращает "Admin" / "User" / null. */
export function getRoleFromToken(token = authToken) {
  if (!token) return null;
  try {
    const payload = JSON.parse(atob(token.split(".")[1]));
    return (
      payload.role ||
      payload[
        "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"
      ] ||
      null
    );
  } catch {
    return null;
  }
}

export function isAdmin(token = authToken) {
  return getRoleFromToken(token) === "Admin";
}

/** Базовый запрос. Кидает Error с .status и .body при не-2xx. */
async function request(path, { method = "GET", body, headers = {}, auth = false, userIdHeader } = {}) {
  const finalHeaders = { ...headers };
  // ngrok-free показывает страницу-предупреждение браузеру; этот заголовок её пропускает,
  // чтобы возвращался реальный JSON, а не HTML.
  finalHeaders["ngrok-skip-browser-warning"] = "true";
  if (body !== undefined) finalHeaders["Content-Type"] = "application/json";
  if (auth && authToken) finalHeaders["Authorization"] = `Bearer ${authToken}`;
  if (userIdHeader) finalHeaders["X-User-Id"] = userIdHeader;

  let res;
  try {
    res = await fetch(`${API_BASE}${path}`, {
      method,
      headers: finalHeaders,
      body: body !== undefined ? JSON.stringify(body) : undefined,
    });
  } catch {
    const err = new Error("Помилка з'єднання з сервером.");
    err.status = 0;
    throw err;
  }

  const text = await res.text();
  let data;
  try {
    data = text ? JSON.parse(text) : null;
  } catch {
    data = text;
  }

  if (!res.ok) {
    const err = new Error(
      typeof data === "string" && data ? data : `Запит не вдався (${res.status})`
    );
    err.status = res.status;
    err.body = data;
    throw err;
  }
  return data;
}

/* ---------------- AUTH ---------------- */

export const auth = {
  register({ email, password, displayName }) {
    return request("/api/auth/register", {
      method: "POST",
      body: { email, password, displayName: displayName || undefined },
    });
  },

  async login({ email, password }) {
    const data = await request("/api/auth/login", {
      method: "POST",
      body: { email, password },
    });
    const token = data?.token ?? data?.Token;
    if (token) setToken(token);
    return { token, raw: data };
  },

  logout() {
    clearToken();
  },
};

/* ------------- SLEEP RECORDS ------------- */

export const sleepRecords = {
  /** record: { userId, sleepDate, sleepStart, sleepEnd, durationMinutes, sleepEfficiency, ... } */
  create(record) {
    const userId = record.userId ?? getUserIdFromToken();
    return request("/api/SleepRecords", {
      method: "POST",
      auth: true,
      body: { ...record, userId },
    });
  },

  listByUser(userId = getUserIdFromToken()) {
    return request(`/api/SleepRecords/user/${userId}`, { auth: true });
  },
};

/* ------------- USER PROFILE ------------- */

export const userProfiles = {
  /** profile: { userId, sleepGoal, preferredSleepTime: "23:00:00", preferredWakeTime: "07:00:00" } */
  save(profile) {
    const userId = profile.userId ?? getUserIdFromToken();
    return request("/api/UserProfiles", {
      method: "POST",
      auth: true,
      body: { ...profile, userId },
    });
  },
};

/* ------------- JOURNAL ENTRIES ------------- */
/* Бэкенд берёт userId из заголовка X-User-Id (с дефолтным fallback). */

export const entries = {
  list() {
    return request("/api/v1/entries", {
      auth: true,
      userIdHeader: getUserIdFromToken() ?? undefined,
    });
  },

  getById(id) {
    return request(`/api/v1/entries/${id}`, {
      auth: true,
      userIdHeader: getUserIdFromToken() ?? undefined,
    });
  },

  /** entry: { content, mood } */
  create(entry) {
    return request("/api/v1/entries", {
      method: "POST",
      auth: true,
      userIdHeader: getUserIdFromToken() ?? undefined,
      body: entry,
    });
  },

  update(id, entry) {
    return request(`/api/v1/entries/${id}`, {
      method: "PUT",
      auth: true,
      userIdHeader: getUserIdFromToken() ?? undefined,
      body: entry,
    });
  },

  remove(id) {
    return request(`/api/v1/entries/${id}`, {
      method: "DELETE",
      auth: true,
      userIdHeader: getUserIdFromToken() ?? undefined,
    });
  },
};

/* ------------- USERS ------------- */

export const users = {
  count() {
    return request("/api/v1/users/count");
  },
};

/* ------------- ADMIN ------------- */
/* Все эндпоинты требуют JWT с ролью Admin. */

export const admin = {
  /** Список пользователей с пагинацией и поиском. */
  listUsers({ page = 1, pageSize = 20, search = "" } = {}) {
    const q = new URLSearchParams({ page, pageSize });
    if (search) q.set("search", search);
    return request(`/api/admin/users?${q.toString()}`, { auth: true });
  },

  getUser(id) {
    return request(`/api/admin/users/${id}`, { auth: true });
  },

  /** data: { email, displayName, role } */
  updateUser(id, data) {
    return request(`/api/admin/users/${id}`, {
      method: "PUT",
      auth: true,
      body: data,
    });
  },

  deleteUser(id) {
    return request(`/api/admin/users/${id}`, {
      method: "DELETE",
      auth: true,
    });
  },

  /** Блокировка/разблокировка: isActive true|false */
  setStatus(id, isActive) {
    return request(`/api/admin/users/${id}/status`, {
      method: "PATCH",
      auth: true,
      body: { isActive },
    });
  },

  /** Смена роли: "Admin" | "User" */
  setRole(id, role) {
    return request(`/api/admin/users/${id}/role`, {
      method: "PATCH",
      auth: true,
      body: { role },
    });
  },

  resetPassword(id) {
    return request(`/api/admin/users/${id}/reset-password`, {
      method: "POST",
      auth: true,
    });
  },

  stats() {
    return request("/api/admin/stats", { auth: true });
  },

  userSleepRecords(id) {
    return request(`/api/admin/users/${id}/sleep-records`, { auth: true });
  },
};

export default { auth, sleepRecords, userProfiles, entries, users, admin, setToken, getToken, clearToken, getUserIdFromToken, getRoleFromToken, isAdmin };
