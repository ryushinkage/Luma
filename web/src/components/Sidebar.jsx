import { NavLink } from "react-router-dom";
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
} from "lucide-react";

export default function Sidebar() {
    const menuItems = [
        { title: "Дашборд", path: "/dashboard", icon: LayoutDashboard },
        { title: "ШІ-інсайти", path: "/insights", icon: Sparkles },
        { title: "Звички", path: "/habits", icon: CheckSquare },
        { title: "Друзі", path: "/friends", icon: Users },
        { title: "Звіти", path: "/reports", icon: FileText },
        { title: "Цілі", path: "/goals", icon: Target },
    ];

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
                <NavLink to="/settings" className="sidebar__link">
                    <Settings size={18} />
                    <span>Налаштування</span>
                </NavLink>

                <button className="sidebar__link sidebar__logout">
                    <LogOut size={18} />
                    <span>Вийти</span>
                </button>
            </div>
        </aside>
    );
}