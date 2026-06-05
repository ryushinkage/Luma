import { Sparkles, Coffee, Moon, TrendingDown } from "lucide-react";
import Sidebar from "../components/Sidebar";
import Header from "../components/Header";

const insightCards = [
    {
        icon: Coffee,
        title: "Оптимальний час для кави",
        text: "Ваш рівень енергії падає близько 14:00. Чашка кави з 13:30 може покращити вашу продуктивність без шкоди для нічного сну.",
    },
    {
        icon: Moon,
        title: "Покращення якості сну",
        text: "За останні 3 дні тривалість глибокого сну зросла на 15%. Продовжуйте уникати екранів за годину до сну.",
    },
    {
        icon: TrendingDown,
        title: "Зниження ефективності",
        text: "У дні, коли ви лягаєте після 23:30, ваша продуктивність наступного ранку знижується на 20%. Спробуйте зсунути графік на 30 хвилин.",
    },
];

export default function Insights() {
    return (
        <div className="app-layout">
            <Sidebar />

            <main className="page">
                <Header title="Огляд за тиждень" />

                <div className="dashboard">
                    <div className="panel__head" style={{ marginBottom: 8 }}>
                        <div className="ai-head">
                            <div className="ai-head__icon">
                                <Sparkles size={18} />
                            </div>
                            <div>
                                <h3>ШІ-Інсайти</h3>
                                <p>Персоналізовані рекомендації на основі ваших даних</p>
                            </div>
                        </div>
                    </div>

                    {/* Главный инсайт недели */}
                    <div className="panel" style={{ marginBottom: 20 }}>
                        <div className="ai-head">
                            <div className="ai-head__icon">
                                <Sparkles size={18} />
                            </div>
                            <h3>Головне спостереження тижня</h3>
                        </div>
                        <p style={{ color: "var(--text-secondary, #b7c1d9)", lineHeight: 1.6, margin: "12px 0 18px" }}>
                            Ваш циркадний ритм стабілізувався. Ми помітили, що збільшується
                            частка глибокого сну на 24%. Продовжуйте підтримувати ці умови
                            для максимального відновлення.
                        </p>
                        <button className="ai-report">Застосувати до моїх звичок</button>
                    </div>

                    {/* Карточки инсайтов */}
                    <div className="features__grid">
                        {insightCards.map(({ icon: Icon, title, text }) => (
                            <article className="panel" key={title}>
                                <div className="ai-head__icon" style={{ marginBottom: 12 }}>
                                    <Icon size={18} />
                                </div>
                                <h3 style={{ marginBottom: 8 }}>{title}</h3>
                                <p style={{ color: "var(--text-secondary, #b7c1d9)", lineHeight: 1.5 }}>
                                    {text}
                                </p>
                            </article>
                        ))}
                    </div>
                </div>
            </main>
        </div>
    );
}
