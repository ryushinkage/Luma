import { useEffect, useState, useCallback } from "react";
import { admin, getUserIdFromToken } from "../api";

/**
 * Sleep Analytics — Адмін-панель.
 * Працює з /api/admin/* (потрібен JWT з роллю Admin).
 * Можливості: статистика, список користувачів (пошук + пагінація),
 * редагування, зміна ролі, блокування, скидання пароля, видалення.
 */

const C = {
  bg: "#060816", bg2: "#0B1020", card: "#141D33", card2: "#18243D",
  glass: "rgba(255,255,255,0.06)", border: "rgba(255,255,255,0.10)",
  accent: "#7C5CFF", accent2: "#4DA8FF", success: "#6EE7B7",
  warn: "#FBBF24", danger: "#FF6B7A",
  textPrimary: "#F5F7FF", textSecondary: "#B7C1D9", textMuted: "#7D8AA8",
};
const GRADIENT = `linear-gradient(135deg, ${C.accent} 0%, ${C.accent2} 100%)`;
const PAGE_SIZE = 20;

export default function AdminPage({ onLogout }) {
  const [stats, setStats] = useState(null);
  const [users, setUsers] = useState([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState("");
  const [searchInput, setSearchInput] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [editing, setEditing] = useState(null); // user being edited
  const currentUserId = getUserIdFromToken();

  const loadStats = useCallback(async () => {
    try {
      setStats(await admin.stats());
    } catch (e) {
      // статистика не критична — не валим всю страницу
      console.error(e);
    }
  }, []);

  const loadUsers = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const data = await admin.listUsers({ page, pageSize: PAGE_SIZE, search });
      setUsers(data.items ?? []);
      setTotal(data.total ?? 0);
    } catch (e) {
      setError(e.message || "Не вдалося завантажити користувачів.");
    } finally {
      setLoading(false);
    }
  }, [page, search]);

  useEffect(() => { loadStats(); }, [loadStats]);
  useEffect(() => { loadUsers(); }, [loadUsers]);

  function submitSearch(e) {
    e.preventDefault();
    setPage(1);
    setSearch(searchInput.trim());
  }

  async function toggleStatus(u) {
    try {
      await admin.setStatus(u.id, !u.isActive);
      setUsers((list) => list.map((x) => x.id === u.id ? { ...x, isActive: !u.isActive } : x));
    } catch (e) { setError(e.message); }
  }

  async function changeRole(u, role) {
    try {
      await admin.setRole(u.id, role);
      setUsers((list) => list.map((x) => x.id === u.id ? { ...x, role } : x));
    } catch (e) { setError(e.message); }
  }

  async function removeUser(u) {
    if (!window.confirm(`Видалити користувача ${u.email}? Дію не можна скасувати.`)) return;
    try {
      await admin.deleteUser(u.id);
      setUsers((list) => list.filter((x) => x.id !== u.id));
      setTotal((t) => Math.max(0, t - 1));
    } catch (e) { setError(e.message); }
  }

  async function resetPassword(u) {
    if (!window.confirm(`Скинути пароль для ${u.email}?`)) return;
    try {
      const res = await admin.resetPassword(u.id);
      const temp = res?.temporaryPassword ?? res?.newPassword;
      window.alert(temp ? `Тимчасовий пароль: ${temp}` : "Пароль скинуто.");
    } catch (e) { setError(e.message); }
  }

  const totalPages = Math.max(1, Math.ceil(total / PAGE_SIZE));

  return (
    <div style={s.page}>
      <div style={s.wrap}>
        <header style={s.header}>
          <div>
            <h1 style={s.title}>Адмін-панель</h1>
            <p style={s.subtitle}>Керування обліковими записами користувачів</p>
          </div>
          {onLogout && (
            <button style={s.ghostBtn} onClick={onLogout}>Вийти</button>
          )}
        </header>

        {/* Статистика */}
        <div style={s.statsRow}>
          <StatCard label="Усього" value={stats?.totalUsers} />
          <StatCard label="Активних" value={stats?.activeUsers} accent={C.success} />
          <StatCard label="Premium" value={stats?.premiumUsers} accent={C.accent2} />
          <StatCard label="Нових за тиждень" value={stats?.newUsersThisWeek} accent={C.warn} />
        </div>

        {/* Поиск */}
        <form onSubmit={submitSearch} style={s.searchRow}>
          <input
            style={s.search}
            placeholder="Пошук за email або ім'ям…"
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
          />
          <button type="submit" style={s.primaryBtn}>Знайти</button>
          {search && (
            <button type="button" style={s.ghostBtn}
              onClick={() => { setSearch(""); setSearchInput(""); setPage(1); }}>
              Скинути
            </button>
          )}
        </form>

        {error && <div style={s.error}>{error}</div>}

        {/* Таблица */}
        <div style={s.tableCard}>
          <div style={{ ...s.tr, ...s.th }}>
            <span style={s.cEmail}>Email</span>
            <span style={s.cName}>Ім'я</span>
            <span style={s.cRole}>Роль</span>
            <span style={s.cStatus}>Статус</span>
            <span style={s.cActions}>Дії</span>
          </div>

          {loading ? (
            <div style={s.empty}>Завантаження…</div>
          ) : users.length === 0 ? (
            <div style={s.empty}>Користувачів не знайдено</div>
          ) : (
            users.map((u) => {
              const isSelf = u.id === currentUserId;
              return (
                <div key={u.id} style={s.tr}>
                  <span style={s.cEmail}>
                    {u.email}
                    {u.isPremium && <span style={s.premiumTag}>PRO</span>}
                  </span>
                  <span style={s.cName}>{u.displayName || "—"}</span>
                  <span style={s.cRole}>
                    <select
                      style={s.roleSelect}
                      value={u.role}
                      disabled={isSelf}
                      onChange={(e) => changeRole(u, e.target.value)}
                      title={isSelf ? "Не можна змінити власну роль" : ""}
                    >
                      <option value="User">User</option>
                      <option value="Admin">Admin</option>
                    </select>
                  </span>
                  <span style={s.cStatus}>
                    <span style={{
                      ...s.badge,
                      color: u.isActive ? C.success : C.danger,
                      background: (u.isActive ? C.success : C.danger) + "1A",
                    }}>
                      {u.isActive ? "Активний" : "Заблокований"}
                    </span>
                  </span>
                  <span style={s.cActions}>
                    <button style={s.iconBtn} onClick={() => setEditing(u)} title="Редагувати">✎</button>
                    <button style={s.iconBtn} onClick={() => toggleStatus(u)} disabled={isSelf}
                      title={isSelf ? "Не можна заблокувати себе" : (u.isActive ? "Заблокувати" : "Розблокувати")}>
                      {u.isActive ? "⊘" : "✓"}
                    </button>
                    <button style={s.iconBtn} onClick={() => resetPassword(u)} title="Скинути пароль">⟳</button>
                    <button style={{ ...s.iconBtn, color: C.danger }} onClick={() => removeUser(u)}
                      disabled={isSelf} title={isSelf ? "Не можна видалити себе" : "Видалити"}>🗑</button>
                  </span>
                </div>
              );
            })
          )}
        </div>

        {/* Пагинация */}
        <div style={s.pager}>
          <button style={s.ghostBtn} disabled={page <= 1}
            onClick={() => setPage((p) => p - 1)}>← Назад</button>
          <span style={s.pagerInfo}>Сторінка {page} з {totalPages} · {total} всього</span>
          <button style={s.ghostBtn} disabled={page >= totalPages}
            onClick={() => setPage((p) => p + 1)}>Далі →</button>
        </div>
      </div>

      {editing && (
        <EditModal
          user={editing}
          onClose={() => setEditing(null)}
          onSaved={(updated) => {
            setUsers((list) => list.map((x) => x.id === updated.id ? { ...x, ...updated } : x));
            setEditing(null);
          }}
        />
      )}
    </div>
  );
}

function StatCard({ label, value, accent = C.accent }) {
  return (
    <div style={s.statCard}>
      <div style={{ ...s.statValue, color: accent }}>{value ?? "—"}</div>
      <div style={s.statLabel}>{label}</div>
    </div>
  );
}

function EditModal({ user, onClose, onSaved }) {
  const [email, setEmail] = useState(user.email || "");
  const [displayName, setDisplayName] = useState(user.displayName || "");
  const [role, setRole] = useState(user.role || "User");
  const [saving, setSaving] = useState(false);
  const [err, setErr] = useState("");

  async function save() {
    setSaving(true);
    setErr("");
    try {
      await admin.updateUser(user.id, { email: email.trim(), displayName: displayName.trim(), role });
      onSaved({ id: user.id, email: email.trim(), displayName: displayName.trim(), role });
    } catch (e) {
      setErr(e.message || "Не вдалося зберегти.");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div style={s.overlay} onClick={onClose}>
      <div style={s.modal} onClick={(e) => e.stopPropagation()}>
        <h2 style={s.modalTitle}>Редагувати користувача</h2>
        <label style={s.label}>Email</label>
        <input style={s.input} value={email} onChange={(e) => setEmail(e.target.value)} />
        <label style={s.label}>Ім'я</label>
        <input style={s.input} value={displayName} onChange={(e) => setDisplayName(e.target.value)} />
        <label style={s.label}>Роль</label>
        <select style={s.input} value={role} onChange={(e) => setRole(e.target.value)}>
          <option value="User">User</option>
          <option value="Admin">Admin</option>
        </select>
        {err && <div style={s.error}>{err}</div>}
        <div style={s.modalActions}>
          <button style={s.ghostBtn} onClick={onClose}>Скасувати</button>
          <button style={s.primaryBtn} onClick={save} disabled={saving}>
            {saving ? "Збереження…" : "Зберегти"}
          </button>
        </div>
      </div>
    </div>
  );
}

const s = {
  page: { minHeight: "100vh", background: `radial-gradient(1200px 600px at 50% -10%, ${C.bg2} 0%, ${C.bg} 60%)`,
    fontFamily: "'Manrope', system-ui, sans-serif", color: C.textPrimary, padding: "32px 20px" },
  wrap: { maxWidth: 1080, margin: "0 auto" },
  header: { display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 24 },
  title: { margin: 0, fontSize: 28, fontWeight: 700, letterSpacing: "-0.02em" },
  subtitle: { margin: "6px 0 0", color: C.textMuted, fontSize: 14 },
  statsRow: { display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 14, marginBottom: 24 },
  statCard: { background: `linear-gradient(180deg, ${C.card}, ${C.card2})`, border: `1px solid ${C.border}`,
    borderRadius: 16, padding: "18px 20px" },
  statValue: { fontSize: 28, fontWeight: 700 },
  statLabel: { color: C.textMuted, fontSize: 13, marginTop: 4 },
  searchRow: { display: "flex", gap: 10, marginBottom: 18 },
  search: { flex: 1, height: 44, padding: "0 16px", background: C.glass, border: `1px solid ${C.border}`,
    borderRadius: 12, color: C.textPrimary, fontSize: 14, outline: "none" },
  primaryBtn: { height: 44, padding: "0 22px", background: GRADIENT, border: "none", borderRadius: 12,
    color: "#fff", fontSize: 14, fontWeight: 600, cursor: "pointer" },
  ghostBtn: { height: 44, padding: "0 18px", background: C.card2, border: `1px solid ${C.border}`,
    borderRadius: 12, color: C.textSecondary, fontSize: 14, fontWeight: 500, cursor: "pointer" },
  error: { padding: "10px 14px", background: `${C.danger}1A`, border: `1px solid ${C.danger}40`,
    borderRadius: 12, color: C.danger, fontSize: 13, marginBottom: 14 },
  tableCard: { background: `linear-gradient(180deg, ${C.card}, ${C.card2})`, border: `1px solid ${C.border}`,
    borderRadius: 16, overflow: "hidden" },
  tr: { display: "grid", gridTemplateColumns: "2.2fr 1.4fr 1fr 1.1fr 1.3fr", alignItems: "center",
    gap: 12, padding: "14px 20px", borderBottom: `1px solid ${C.border}` },
  th: { color: C.textMuted, fontSize: 12, fontWeight: 600, textTransform: "uppercase", letterSpacing: "0.05em" },
  cEmail: { display: "flex", alignItems: "center", gap: 8, fontSize: 14, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" },
  cName: { fontSize: 14, color: C.textSecondary },
  cRole: {}, cStatus: {}, cActions: { display: "flex", gap: 6, justifyContent: "flex-end" },
  premiumTag: { fontSize: 10, fontWeight: 700, color: C.accent2, background: `${C.accent2}1A`,
    padding: "2px 6px", borderRadius: 6 },
  roleSelect: { background: C.glass, border: `1px solid ${C.border}`, borderRadius: 8, color: C.textPrimary,
    padding: "6px 8px", fontSize: 13, cursor: "pointer" },
  badge: { fontSize: 12, fontWeight: 600, padding: "4px 10px", borderRadius: 8 },
  iconBtn: { width: 32, height: 32, display: "flex", alignItems: "center", justifyContent: "center",
    background: C.glass, border: `1px solid ${C.border}`, borderRadius: 8, color: C.textSecondary,
    cursor: "pointer", fontSize: 14 },
  empty: { padding: "32px 20px", textAlign: "center", color: C.textMuted, fontSize: 14 },
  pager: { display: "flex", justifyContent: "center", alignItems: "center", gap: 16, marginTop: 18 },
  pagerInfo: { color: C.textMuted, fontSize: 13 },
  overlay: { position: "fixed", inset: 0, background: "rgba(3,5,12,0.7)", backdropFilter: "blur(4px)",
    display: "flex", alignItems: "center", justifyContent: "center", padding: 20, zIndex: 50 },
  modal: { width: "100%", maxWidth: 420, background: `linear-gradient(180deg, ${C.card}, ${C.card2})`,
    border: `1px solid ${C.border}`, borderRadius: 20, padding: 28 },
  modalTitle: { margin: "0 0 18px", fontSize: 20, fontWeight: 700 },
  label: { display: "block", margin: "12px 0 6px", fontSize: 13, color: C.textSecondary },
  input: { width: "100%", boxSizing: "border-box", height: 44, padding: "0 14px", background: C.glass,
    border: `1px solid ${C.border}`, borderRadius: 12, color: C.textPrimary, fontSize: 14, outline: "none" },
  modalActions: { display: "flex", justifyContent: "flex-end", gap: 10, marginTop: 22 },
};
