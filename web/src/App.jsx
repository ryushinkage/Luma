import { useState } from "react";
import { Routes, Route } from "react-router-dom";
import AuthScreen from "./components/AuthScreen";
import { setToken as saveToken } from "./api";
import Landing from "./pages/Landing";
import Dashboard from "./pages/Dashboard";
import Habits from "./pages/Habits";

export default function App() {
    const [token, setToken] = useState(null);

    function handleAuthSuccess(jwt) {
        saveToken(jwt);  // сохраняем токен в api-клиенте
        setToken(jwt);   // и в состоянии приложения
    }

    // Пока пользователь не вошёл — показываем экран входа/регистрации
    if (!token) {
        return <AuthScreen onAuthSuccess={handleAuthSuccess} />;
    }

    // После входа — обычная навигация по приложению
    return (
        <Routes>
            <Route path="/" element={<Landing />} />
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/habits" element={<Habits />} />
        </Routes>
    );
}
