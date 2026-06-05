import { useState, useEffect } from "react";
import { Routes, Route, Navigate, useNavigate } from "react-router-dom";
import AuthScreen from "./components/AuthScreen";
import { setToken as saveToken, getToken, clearToken, isAdmin } from "./api";
import Landing from "./pages/Landing";
import Dashboard from "./pages/Dashboard";
import Habits from "./pages/Habits";
import Insights from "./pages/Insights";
import Friends from "./pages/Friends";
import Reports from "./pages/Reports";
import Goals from "./pages/Goals";
import AdminPage from "./pages/AdminPage";

export default function App() {
    // токен входа; восстанавливаем из сохранённого (localStorage), чтобы
    // вход переживал перезагрузку и заход по прямому URL
    const [token, setToken] = useState(() => getToken());
    const loggedIn = Boolean(token);
    const admin = loggedIn && isAdmin(token);

    // Выход из аккаунта (кнопка «Вийти» в сайдбаре шлёт это событие)
    useEffect(() => {
        const onLogout = () => setToken(null);
        window.addEventListener("auth-logout", onLogout);
        return () => window.removeEventListener("auth-logout", onLogout);
    }, []);

    return (
        <Routes>
            {/* Публичная стартовая страница */}
            <Route path="/" element={<Landing />} />

            {/* Экран входа/регистрации */}
            <Route
                path="/login"
                element={
                    loggedIn
                        ? <Navigate to="/dashboard" replace />
                        : <LoginRoute onToken={setToken} />
                }
            />

            {/* Защищённые страницы приложения */}
            <Route path="/dashboard" element={<Protected ok={loggedIn}><Dashboard /></Protected>} />
            <Route path="/insights" element={<Protected ok={loggedIn}><Insights /></Protected>} />
            <Route path="/habits" element={<Protected ok={loggedIn}><Habits /></Protected>} />
            <Route path="/friends" element={<Protected ok={loggedIn}><Friends /></Protected>} />
            <Route path="/reports" element={<Protected ok={loggedIn}><Reports /></Protected>} />
            <Route path="/goals" element={<Protected ok={loggedIn}><Goals /></Protected>} />

            {/* Админка — только для роли Admin */}
            <Route
                path="/admin"
                element={admin ? <AdminPage /> : <Navigate to="/dashboard" replace />}
            />

            {/* Любой неизвестный путь — на стартовую */}
            <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
    );
}

// Обёртка: пускает дальше только если есть токен, иначе на /login
function Protected({ ok, children }) {
    if (!ok) return <Navigate to="/login" replace />;
    return children;
}

// Экран входа: сохраняет токен и переводит дальше (админа — в админку)
function LoginRoute({ onToken }) {
    const navigate = useNavigate();
    function handleAuthSuccess(jwt) {
        saveToken(jwt);   // в api-клиент (+ localStorage)
        onToken(jwt);     // в состояние приложения
        const dest = isAdmin(jwt) ? "/admin" : "/dashboard";
        navigate(dest, { replace: true });
    }
    return <AuthScreen onAuthSuccess={handleAuthSuccess} />;
}
