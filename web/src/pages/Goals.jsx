import { Target, Plus } from "lucide-react";
import Sidebar from "../components/Sidebar";
import Header from "../components/Header";

const goals = [
    {
        title: "Спати по 8 годин",
        note: "Підтримувати середню тривалість сну не менше 8 годин на день.",
        progress: 75,
        badge: "4дн.",
    },
    {
        title: "Режим сну",
        note: "Лягати спати до 23:00 щодня для стабілізації циркадного ритму.",
        progress: 90,
        badge: "3дн.",
    },
    {
        title: "Цифровий детокс",
        note: "Відмовитись від використання гаджетів за годину до сну.",
        progress: 40,
        badge: "12дн.",
    },
];

export default function Goals() {
    return (
        <div className="app-layout">
            <Sidebar />

            <main className="page">
                <Header title="Огляд за тиждень" />

                <div className="dashboard">
                    <div className="panel__head" style={{ marginBottom: 16 }}>
                        <div className="ai-head">
                            <div className="ai-head__icon">
                                <Target size={18} />
                            </div>
                            <div>
                                <h3>Цілі</h3>
                                <p>Відстежуйте свої звички та досягнення</p>
                            </div>
                        </div>
                        <button className="ai-report" style={{ width: "auto", padding: "10px 18px" }}>
                            <Plus size={16} style={{ marginRight: 6, verticalAlign: "middle" }} />
                            Нова ціль
                        </button>
                    </div>

                    <div className="features__grid">
                        {goals.map((g) => (
                            <article className="panel" key={g.title}>
                                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
                                    <h3 style={{ marginBottom: 8 }}>{g.title}</h3>
                                    <span style={{
                                        fontSize: 12, fontWeight: 600, color: "#4da8ff",
                                        background: "rgba(77,168,255,0.12)", padding: "3px 10px", borderRadius: 8,
                                    }}>
                                        {g.badge}
                                    </span>
                                </div>
                                <p style={{ color: "#b7c1d9", lineHeight: 1.5, marginBottom: 16, fontSize: 14 }}>
                                    {g.note}
                                </p>
                                <div style={{ display: "flex", justifyContent: "space-between", fontSize: 12, color: "#7d8aa8", marginBottom: 6 }}>
                                    <span>Поточний стан</span>
                                    <span>Ціль</span>
                                </div>
                                <div style={{ height: 8, background: "rgba(255,255,255,0.08)", borderRadius: 999, overflow: "hidden" }}>
                                    <div style={{
                                        width: `${g.progress}%`, height: "100%",
                                        background: "linear-gradient(135deg, #7c5cff, #4da8ff)",
                                    }} />
                                </div>
                            </article>
                        ))}

                        {/* Создать собственную */}
                        <article className="panel" style={{
                            display: "flex", flexDirection: "column", alignItems: "center",
                            justifyContent: "center", textAlign: "center", borderStyle: "dashed",
                        }}>
                            <div className="ai-head__icon" style={{ marginBottom: 12 }}>
                                <Plus size={20} />
                            </div>
                            <h3 style={{ marginBottom: 6 }}>Створити власну</h3>
                            <p style={{ color: "#7d8aa8", fontSize: 13 }}>
                                Встановіть нову ціль для кращого сну
                            </p>
                        </article>
                    </div>
                </div>
            </main>
        </div>
    );
}
