import { Bell } from "lucide-react";

export default function Header({ title }) {
    return (
        <header className="header">
            <h2>{title}</h2>

            <div className="header__right">
                <button className="header__icon">
                    <Bell size={18} />
                    <span />
                </button>

                <div className="header__avatar">M</div>
            </div>
        </header>
    );
}