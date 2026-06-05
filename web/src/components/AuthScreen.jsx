import { useState } from "react";
import { auth } from "../api";

/**
 * Sleep Analytics — Auth (Login / Registration)
 * Дизайн по макету и токенам проекта. Запросы идут через общий api-клиент (../api).
 * Google-кнопка — заглушка (реальный OAuth подключается отдельной задачей).
 */

const C = {
  bg: "#060816", bg2: "#0B1020", card: "#141D33", card2: "#18243D",
  glass: "rgba(255,255,255,0.06)", border: "rgba(255,255,255,0.10)",
  accent: "#7C5CFF", accent2: "#4DA8FF", success: "#6EE7B7", danger: "#FF6B7A",
  textPrimary: "#F5F7FF", textSecondary: "#B7C1D9", textMuted: "#7D8AA8",
};
const GRADIENT = `linear-gradient(135deg, ${C.accent} 0%, ${C.accent2} 100%)`;

export default function AuthScreen({ onAuthSuccess }) {
  const [mode, setMode] = useState("login");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [displayName, setDisplayName] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");

  const isLogin = mode === "login";

  function switchMode(next) { setMode(next); setError(""); setInfo(""); }

  async function handleSubmit(e) {
    e.preventDefault();
    setError(""); setInfo("");
    if (!email.trim() || !password) { setError("Введіть email і пароль."); return; }
    setLoading(true);
    try {
      if (isLogin) {
        const { token } = await auth.login({ email: email.trim(), password });
        if (token) onAuthSuccess?.(token);
        else setError("Сервер не повернув токен.");
      } else {
        await auth.register({ email: email.trim(), password, displayName: displayName.trim() });
        const { token } = await auth.login({ email: email.trim(), password });
        if (token) onAuthSuccess?.(token);
        else { setInfo("Акаунт створено. Тепер увійдіть."); switchMode("login"); }
      }
    } catch (err) {
      setError(err.message || "Сталася помилка.");
    } finally {
      setLoading(false);
    }
  }

  function handleGoogle() { setInfo("Google-вхід буде підключено пізніше."); }

  return (
    <div style={styles.page}>
      <div style={styles.glowTop} />
      <div style={styles.glowBottom} />
      <div style={styles.card}>
        <div style={styles.logo}><MoonIcon /></div>
        <h1 style={styles.title}>{isLogin ? "З поверненням" : "Створити акаунт"}</h1>
        <p style={styles.subtitle}>
          {isLogin ? "Увійдіть, щоб продовжити покращувати свій сон"
                   : "Приєднуйтесь до платформи інтелектуального сну"}
        </p>

        <button type="button" style={styles.googleBtn} onClick={handleGoogle}>
          <GoogleIcon /><span>Продовжити з Google</span>
        </button>

        <div style={styles.divider}>
          <span style={styles.dividerLine} />
          <span style={styles.dividerText}>АБО</span>
          <span style={styles.dividerLine} />
        </div>

        <form onSubmit={handleSubmit}>
          {!isLogin && (
            <div style={styles.field}>
              <label style={styles.label}>Ім'я</label>
              <input style={styles.input} type="text" placeholder="Ваше ім'я"
                value={displayName} onChange={(e) => setDisplayName(e.target.value)} autoComplete="name" />
            </div>
          )}
          <div style={styles.field}>
            <label style={styles.label}>Email</label>
            <input style={styles.input} type="email" placeholder="your@email.com"
              value={email} onChange={(e) => setEmail(e.target.value)} autoComplete="email" />
          </div>
          <div style={styles.field}>
            <label style={styles.label}>Пароль</label>
            <input style={styles.input} type="password" placeholder="••••••••"
              value={password} onChange={(e) => setPassword(e.target.value)}
              autoComplete={isLogin ? "current-password" : "new-password"} />
          </div>

          {error && <div style={styles.error}>{error}</div>}
          {info && <div style={styles.info}>{info}</div>}

          <button type="submit" style={styles.submitBtn} disabled={loading}>
            {loading ? "Зачекайте…" : isLogin ? "→ Увійти" : "→ Створити акаунт"}
          </button>
        </form>

        <p style={styles.switchRow}>
          {isLogin ? "Ще не маєте акаунту? " : "Вже маєте акаунт? "}
          <button type="button" style={styles.switchLink}
            onClick={() => switchMode(isLogin ? "register" : "login")}>
            {isLogin ? "Зареєструватися" : "Увійти"}
          </button>
        </p>
      </div>
    </div>
  );
}

function MoonIcon() {
  return (
    <svg width="26" height="26" viewBox="0 0 24 24" fill="none">
      <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" fill="#fff" opacity="0.95" />
    </svg>
  );
}

function GoogleIcon() {
  return (
    <svg width="18" height="18" viewBox="0 0 24 24">
      <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.27-4.74 3.27-8.1z" />
      <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.99.66-2.26 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84A11 11 0 0 0 12 23z" />
      <path fill="#FBBC05" d="M5.84 14.1a6.6 6.6 0 0 1 0-4.2V7.06H2.18a11 11 0 0 0 0 9.88l3.66-2.84z" />
      <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1A11 11 0 0 0 2.18 7.06l3.66 2.84C6.71 7.31 9.14 5.38 12 5.38z" />
    </svg>
  );
}

const styles = {
  page: { position: "relative", minHeight: "100vh", width: "100%", display: "flex",
    alignItems: "center", justifyContent: "center",
    background: `radial-gradient(1200px 600px at 50% -10%, ${C.bg2} 0%, ${C.bg} 60%)`,
    fontFamily: "'Manrope', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
    padding: 24, overflow: "hidden" },
  glowTop: { position: "absolute", top: "-15%", left: "50%", transform: "translateX(-50%)",
    width: 520, height: 520,
    background: `radial-gradient(circle, ${C.accent}33 0%, transparent 70%)`,
    filter: "blur(40px)", pointerEvents: "none" },
  glowBottom: { position: "absolute", bottom: "-20%", right: "10%", width: 420, height: 420,
    background: `radial-gradient(circle, ${C.accent2}26 0%, transparent 70%)`,
    filter: "blur(40px)", pointerEvents: "none" },
  card: { position: "relative", width: "100%", maxWidth: 400,
    background: `linear-gradient(180deg, ${C.card} 0%, ${C.card2} 100%)`,
    border: `1px solid ${C.border}`, borderRadius: 24, padding: "36px 32px",
    boxShadow: "0 24px 60px rgba(0,0,0,0.45), 0 0 0 1px rgba(124,92,255,0.04)",
    backdropFilter: "blur(12px)" },
  logo: { width: 52, height: 52, margin: "0 auto 22px", borderRadius: 16, display: "flex",
    alignItems: "center", justifyContent: "center", background: GRADIENT,
    boxShadow: `0 8px 24px ${C.accent}4D` },
  title: { margin: 0, textAlign: "center", fontSize: 26, fontWeight: 700,
    color: C.textPrimary, letterSpacing: "-0.02em" },
  subtitle: { margin: "10px 0 26px", textAlign: "center", fontSize: 14, color: C.textMuted, lineHeight: 1.5 },
  googleBtn: { width: "100%", height: 48, display: "flex", alignItems: "center",
    justifyContent: "center", gap: 10, background: C.card2, border: `1px solid ${C.border}`,
    borderRadius: 16, color: C.textPrimary, fontSize: 14, fontWeight: 600, cursor: "pointer",
    transition: "all 0.15s ease" },
  divider: { display: "flex", alignItems: "center", gap: 12, margin: "20px 0" },
  dividerLine: { flex: 1, height: 1, background: C.border },
  dividerText: { fontSize: 12, color: C.textMuted, fontWeight: 600, letterSpacing: "0.08em" },
  field: { marginBottom: 16 },
  label: { display: "block", marginBottom: 8, fontSize: 13, fontWeight: 500, color: C.textSecondary },
  input: { width: "100%", height: 48, boxSizing: "border-box", padding: "0 16px",
    background: C.glass, border: `1px solid ${C.border}`, borderRadius: 16,
    color: C.textPrimary, fontSize: 14, outline: "none", transition: "border-color 0.15s ease" },
  error: { marginBottom: 14, padding: "10px 14px", background: `${C.danger}1A`,
    border: `1px solid ${C.danger}40`, borderRadius: 12, color: C.danger, fontSize: 13 },
  info: { marginBottom: 14, padding: "10px 14px", background: `${C.accent2}1A`,
    border: `1px solid ${C.accent2}40`, borderRadius: 12, color: C.accent2, fontSize: 13 },
  submitBtn: { width: "100%", height: 50, marginTop: 6, background: GRADIENT, border: "none",
    borderRadius: 16, color: "#fff", fontSize: 15, fontWeight: 700, cursor: "pointer",
    boxShadow: `0 10px 28px ${C.accent}40`, transition: "transform 0.1s ease, opacity 0.15s ease" },
  switchRow: { margin: "22px 0 0", textAlign: "center", fontSize: 13, color: C.textMuted },
  switchLink: { background: "none", border: "none", padding: 0, color: C.accent2,
    fontSize: 13, fontWeight: 600, cursor: "pointer" },
};
