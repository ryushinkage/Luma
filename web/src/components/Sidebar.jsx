import { NavLink, useNavigate } from "react-router-dom";
import {
    LayoutDashboard,
    Sparkles,
    CheckSquare,
    Users,
    FileText,
    Target,
    Settings,
    LogOut,
    Moon,
    Shield,
} from "lucide-react";
import { clearToken, isAdmin } from "../api";

export default function Sidebar({ onLogout }) {
    const navigate = useNavigate();

    const menuItems = [
        { title: "Дашборд", path: "/dashboard", icon: LayoutDashboard },
        { title: "ШІ-інсайти", path: "/insights", icon: Sparkles },
        { title: "Звички", path: "/habits", icon: CheckSquare },
        { title: "Друзі", path: "/friends", icon: Users },
        { title: "Звіти", path: "/reports", icon: FileText },
        { title: "Цілі", path: "/goals", icon: Target },
    ];

    // Пункт «Адмінка» показываем только пользователям с ролью Admin
    if (isAdmin()) {
        menuItems.push({ title: "Адмінка", path: "/admin", icon: Shield });
    }

    function handleLogout() {
        clearToken();          // чистим токен в api-клиенте
        if (onLogout) onLogout(); // если проп передан напрямую
        // оповещаем App о выходе (без прокидывания пропов через все страницы)
        window.dispatchEvent(new Event("auth-logout"));
        navigate("/", { replace: true }); // на стартовую
    }

    function handleSettings(e) {
        // Страницы настроек пока нет — не даём уйти в никуда
        e.preventDefault();
    }

    return (
        <aside className="sidebar">
            <div className="sidebar__logo">
                <div className="sidebar__logo-icon">
                    <Moon size={22} />
                </div>
                <span>SleepAnalytics</span>
            </div>

            <nav className="sidebar__nav">
                {menuItems.map(({ title, path, icon: Icon }) => (
                    <NavLink
                        key={path}
                        to={path}
                        className={({ isActive }) =>
                            isActive ? "sidebar__link active" : "sidebar__link"
                        }
                    >
                        <Icon size={18} />
                        <span>{title}</span>
                    </NavLink>
                ))}
            </nav>

            <div className="sidebar__bottom">
                <button
                    type="button"
                    className="sidebar__link"
                    onClick={handleSettings}
                >
                    <Settings size={18} />
                    <span>Налаштування</span>
                </button>

                <button
                    type="button"
                    className="sidebar__link sidebar__logout"
                    onClick={handleLogout}
                >
                    <LogOut size={18} />
                    <span>Вийти</span>
                </button>
            </div>
        </aside>
    );
}
