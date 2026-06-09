import { Activity, CheckCircle2, TrendingUp, Flame, Plus } from "lucide-react";
import Sidebar from "../components/Sidebar";
import Header from "../components/Header";

const habitsData = [
    { title: "Ранкова прогулянка", desc: "15 хвилин на свіжому повітрі після пробудження", icon: "🚶", streak: 7, days: [true, true, true, true, true, false, true] },
    { title: "Медитація перед сном", desc: "10 хвилин дихальних вправ або медитації", icon: "🧘", streak: 5, days: [true, false, true, true, false, true, false] },
    { title: "Відмова від кофеїну після 16:00", desc: "Зберегти енергію та якість сну в другій половині дня", icon: "☕", streak: 12, days: [true, true, true, true, true, true, true] },
    { title: "Читання перед сном", desc: "20 хвилин читання паперової книги", icon: "📖", streak: 3, days: [true, true, true, false, false, false, false] },
    { title: "Відключення гаджетів", desc: "Без екранів за 1 годину до сну", icon: "📵", streak: 9, days: [true, true, false, true, true, true, true] },
    { title: "Вечірній душ", desc: "Теплий душ за 30 хвилин до сну", icon: "🚿", streak: 4, days: [true, true, true, true, false, false, false] },
];

const dayLabels = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Нд"];

const stats = [
    { label: "Виконано сьогодні", value: "3 /6", icon: CheckCircle2, color: "#6EE7B7" },
    { label: "Відсоток виконання", value: "50%", icon: TrendingUp, color: "#4DA8FF" },
    { label: "Найдовша серія", value: "12 днів", icon: Flame, color: "#FBBF24" },
];

export default function Habits() {
    return (
        <div className="app-layout">
            <Sidebar />

            <main className="page">
                <Header title="Огляд за тиждень" />

                <div className="dashboard">
                    <div className="panel__head" style={{ marginBottom: 16 }}>
                        <div className="ai-head">
                            <div className="ai-head__icon">
                                <Activity size={18} />
                            </div>
                            <div>
                                <h3>Щоденні звички</h3>
                                <p>Формуйте здоровий режим сну крок за кроком</p>
                            </div>
                        </div>
                        <button className="ai-report" style={{ width: "auto", padding: "10px 18px" }}>
                            <Plus size={16} style={{ marginRight: 6, verticalAlign: "middle" }} />
                            Нова звичка
                        </button>
                    </div>

                    {/* Статистика */}
                    <div className="stats-grid" style={{ marginBottom: 20 }}>
                        {stats.map((s) => {
                            const Icon = s.icon;
                            return (
                                <div className="stat-card" key={s.label}>
                                    <div className="stat-card__top">
                                        <span className="stat-card__label">{s.label}</span>
                                        <div className="stat-card__icon" style={{ color: s.color }}>
                                            <Icon size={18} />
                                        </div>
                                    </div>
                                    <div className="stat-card__value">{s.value}</div>
                                </div>
                            );
                        })}
                    </div>

                    {/* Карточки привычек */}
                    <div className="features__grid">
                        {habitsData.map((h) => (
                            <article className="panel" key={h.title}>
                                <div style={{ display: "flex", alignItems: "flex-start", justifyContent: "space-between", gap: 12 }}>
                                    <div style={{ display: "flex", gap: 12, alignItems: "flex-start" }}>
                                        <div style={{
                                            width: 42, height: 42, borderRadius: 12, flexShrink: 0,
                                            display: "flex", alignItems: "center", justifyContent: "center",
                                            background: "rgba(255,255,255,0.06)", fontSize: 20,
                                        }}>
                                            {h.icon}
                                        </div>
                                        <div>
                                            <h3 style={{ fontSize: 15, marginBottom: 4 }}>{h.title}</h3>
                                            <p style={{ color: "#7d8aa8", fontSize: 13, lineHeight: 1.4 }}>{h.desc}</p>
                                        </div>
                                    </div>
                                    <span style={{
                                        fontSize: 13, fontWeight: 700, color: "#fff", flexShrink: 0,
                                        width: 28, height: 28, borderRadius: 8,
                                        display: "flex", alignItems: "center", justifyContent: "center",
                                        background: "rgba(255,255,255,0.06)",
                                    }}>
                                        {h.streak}
                                    </span>
                                </div>

                                {/* Трекер по дням */}
                                <div style={{ display: "flex", justifyContent: "space-between", marginTop: 16 }}>
                                    {h.days.map((done, i) => (
                                        <div key={i} style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 6 }}>
                                            <div style={{
                                                width: 30, height: 30, borderRadius: "50%",
                                                display: "flex", alignItems: "center", justifyContent: "center",
                                                background: done ? "linear-gradient(135deg, #7c5cff, #4da8ff)" : "rgba(255,255,255,0.05)",
                                                border: done ? "none" : "1px solid rgba(255,255,255,0.10)",
                                                color: done ? "#fff" : "#7d8aa8", fontSize: 12,
                                            }}>
                                                {done ? "✓" : ""}
                                            </div>
                                            <span style={{ fontSize: 10, color: "#7d8aa8" }}>{dayLabels[i]}</span>
                                        </div>
                                    ))}
                                </div>
                            </article>
                        ))}
                    </div>
                </div>
            </main>
        </div>
    );
}
