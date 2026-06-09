import {
    AreaChart, Area, BarChart, Bar, XAxis, YAxis,
    CartesianGrid, ResponsiveContainer, Legend,
} from "recharts";
import { FileText, Download } from "lucide-react";
import Sidebar from "../components/Sidebar";
import Header from "../components/Header";

const durationData = [
    { day: "Пн", value: 6.5 },
    { day: "Вт", value: 7.2 },
    { day: "Ср", value: 7.8 },
    { day: "Чт", value: 7.0 },
    { day: "Пт", value: 6.8 },
    { day: "Сб", value: 8.1 },
    { day: "Нд", value: 7.6 },
];

const phaseData = [
    { day: "Пн", quality: 82, deep: 2.1 },
    { day: "Вт", quality: 86, deep: 2.4 },
    { day: "Ср", quality: 90, deep: 2.6 },
    { day: "Чт", quality: 84, deep: 2.2 },
    { day: "Пт", quality: 80, deep: 2.0 },
    { day: "Сб", quality: 92, deep: 2.8 },
    { day: "Нд", quality: 88, deep: 2.5 },
];

const summary = [
    { label: "Середня тривалість", value: "7.5", accent: "#F5F7FF" },
    { label: "Середня якість", value: "86", accent: "#F5F7FF" },
    { label: "Глибокий сон", value: "2.3", accent: "#7C5CFF" },
    { label: "Ефективність сну", value: "92", accent: "#6EE7B7" },
];

export default function Reports() {
    return (
        <div className="app-layout">
            <Sidebar />

            <main className="page">
                <Header title="Огляд за тиждень" />

                <div className="dashboard">
                    <div className="panel__head" style={{ marginBottom: 16 }}>
                        <div className="ai-head">
                            <div className="ai-head__icon">
                                <FileText size={18} />
                            </div>
                            <div>
                                <h3>Звіти</h3>
                                <p>Детальна статистика та експорт даних</p>
                            </div>
                        </div>
                        <button className="ai-report" style={{ width: "auto", padding: "10px 18px" }}>
                            <Download size={16} style={{ marginRight: 6, verticalAlign: "middle" }} />
                            Експорт PDF
                        </button>
                    </div>

                    <div className="dashboard__grid">
                        <div className="panel">
                            <div className="panel__head">
                                <div><h3>Тривалість сну (Години)</h3></div>
                            </div>
                            <ResponsiveContainer width="100%" height={220}>
                                <AreaChart data={durationData}>
                                    <defs>
                                        <linearGradient id="dur" x1="0" y1="0" x2="0" y2="1">
                                            <stop offset="0%" stopColor="#4da8ff" stopOpacity={0.4} />
                                            <stop offset="100%" stopColor="#4da8ff" stopOpacity={0} />
                                        </linearGradient>
                                    </defs>
                                    <CartesianGrid vertical={false} stroke="#18243d" />
                                    <XAxis dataKey="day" tickLine={false} axisLine={false} tick={{ fill: "#b7c1d9", fontSize: 12 }} />
                                    <YAxis tickLine={false} axisLine={false} tick={{ fill: "#b7c1d9", fontSize: 12 }} width={28} />
                                    <Area type="monotone" dataKey="value" stroke="#4da8ff" strokeWidth={2} fill="url(#dur)" />
                                </AreaChart>
                            </ResponsiveContainer>
                        </div>

                        <div className="panel">
                            <div className="panel__head">
                                <div><h3>Фази сну та Якість</h3></div>
                            </div>
                            <ResponsiveContainer width="100%" height={220}>
                                <BarChart data={phaseData} barCategoryGap="28%">
                                    <CartesianGrid vertical={false} stroke="#18243d" />
                                    <XAxis dataKey="day" tickLine={false} axisLine={false} tick={{ fill: "#b7c1d9", fontSize: 12 }} />
                                    <YAxis tickLine={false} axisLine={false} tick={{ fill: "#b7c1d9", fontSize: 12 }} width={28} />
                                    <Legend wrapperStyle={{ fontSize: 12, color: "#b7c1d9" }} />
                                    <Bar dataKey="quality" name="Якість (%)" fill="#7c5cff" radius={[6, 6, 0, 0]} />
                                    <Bar dataKey="deep" name="Глибокий сон (год)" fill="#4da8ff" radius={[6, 6, 0, 0]} />
                                </BarChart>
                            </ResponsiveContainer>
                        </div>
                    </div>

                    <div className="panel" style={{ marginTop: 20 }}>
                        <h3 className="panel__title">Підсумок за період</h3>
                        <div className="stats-grid" style={{ marginTop: 12 }}>
                            {summary.map((s) => (
                                <div className="stat-card" key={s.label}>
                                    <div className="stat-card__label">{s.label}</div>
                                    <div className="stat-card__value" style={{ color: s.accent }}>{s.value}</div>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            </main>
        </div>
    );
}
