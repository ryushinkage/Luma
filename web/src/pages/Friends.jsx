import { Users, Trophy, Plus } from "lucide-react";
import Sidebar from "../components/Sidebar";
import Header from "../components/Header";

const leaderboard = [
    { place: 1, name: "Олександр М.", score: 92, delta: "+4", hours: "8.1г", regularity: "95%" },
    { place: 2, name: "Ви (Ти)", score: 85, delta: "+2", hours: "7.7г", regularity: "88%", me: true },
    { place: 3, name: "Марія К.", score: 82, delta: "-1", hours: "7.2г", regularity: "80%" },
    { place: 4, name: "Іван Д.", score: 76, delta: "-3", hours: "6.5г", regularity: "72%" },
    { place: 5, name: "Анна С.", score: 68, delta: "+1", hours: "6.0г", regularity: "65%" },
];

const scoring = [
    { title: "Якість сну (до 50 балів)", note: "Базується на співвідношенні глибокого та REM сну." },
    { title: "Тривалість (до 30 балів)", note: "Максимум за досягнення індивідуальної норми 7.5–8.5 год." },
    { title: "Регулярність (до 20 балів)", note: "Лягати спати в один і той же час." },
];

export default function Friends() {
    return (
        <div className="app-layout">
            <Sidebar />

            <main className="page">
                <Header title="Огляд за тиждень" />

                <div className="dashboard">
                    <div className="panel__head" style={{ marginBottom: 16 }}>
                        <div className="ai-head">
                            <div className="ai-head__icon">
                                <Users size={18} />
                            </div>
                            <div>
                                <h3>Спільнота &amp; Друзі</h3>
                                <p>Відстежуйте прогрес друзів та мотивуйте один одного до кращого сну</p>
                            </div>
                        </div>
                        <button className="ai-report" style={{ width: "auto", padding: "10px 18px" }}>
                            <Plus size={16} style={{ marginRight: 6, verticalAlign: "middle" }} />
                            Додати друга
                        </button>
                    </div>

                    <div className="dashboard__grid">
                        <div className="dashboard__main">
                            <div className="panel">
                                <table style={{ width: "100%", borderCollapse: "collapse" }}>
                                    <thead>
                                        <tr style={{ textAlign: "left", color: "#7d8aa8", fontSize: 13 }}>
                                            <th style={{ padding: "10px 8px" }}>Місце</th>
                                            <th style={{ padding: "10px 8px" }}>Користувач</th>
                                            <th style={{ padding: "10px 8px" }}>Оцінка сну</th>
                                            <th style={{ padding: "10px 8px" }}>Години сну</th>
                                            <th style={{ padding: "10px 8px" }}>Регулярність</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {leaderboard.map((u) => (
                                            <tr
                                                key={u.place}
                                                style={{
                                                    borderTop: "1px solid rgba(255,255,255,0.08)",
                                                    background: u.me ? "rgba(124,92,255,0.10)" : "transparent",
                                                }}
                                            >
                                                <td style={{ padding: "14px 8px" }}>
                                                    {u.place <= 3 ? (
                                                        <Trophy size={18} color={["#FBBF24", "#B7C1D9", "#CD7F32"][u.place - 1]} />
                                                    ) : (
                                                        u.place
                                                    )}
                                                </td>
                                                <td style={{ padding: "14px 8px", fontWeight: u.me ? 700 : 500 }}>{u.name}</td>
                                                <td style={{ padding: "14px 8px" }}>
                                                    <strong>{u.score}</strong>{" "}
                                                    <span style={{ color: u.delta.startsWith("+") ? "#6EE7B7" : "#FF6B7A", fontSize: 12 }}>
                                                        {u.delta}
                                                    </span>
                                                </td>
                                                <td style={{ padding: "14px 8px", color: "#b7c1d9" }}>{u.hours}</td>
                                                <td style={{ padding: "14px 8px", color: "#b7c1d9" }}>{u.regularity}</td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div className="dashboard__side">
                            <div className="panel">
                                <h3 className="panel__title">Як нараховуються бали?</h3>
                                <div className="factors">
                                    {scoring.map((item) => (
                                        <div className="factor" key={item.title}>
                                            <div className="factor__text">
                                                <span className="factor__title">{item.title}</span>
                                                <span className="factor__note">{item.note}</span>
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            </div>

                            <div className="panel">
                                <h3 className="panel__title">Киньте виклик!</h3>
                                <p style={{ color: "#b7c1d9", lineHeight: 1.5, margin: "8px 0 16px" }}>
                                    Спільні цілі допомагають покращити сон на 24% швидше.
                                </p>
                                <button className="ai-report">Створити змагання</button>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    );
}
