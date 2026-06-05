import {
    BarChart, Bar, XAxis, YAxis, ResponsiveContainer,
    Area, AreaChart, CartesianGrid,
} from "recharts";
import {
    Brain, Coffee, Smartphone, Dumbbell,
    Gauge, Clock, BatteryCharging, Activity,
} from "lucide-react";
import Sidebar from "../components/Sidebar";
import Header from "../components/Header";
import {
    sleepStats, sleepPhases, recoveryData, aiInsights, behaviorFactors,
} from "../mock/mockData";

const statIcons = {
    score: Gauge, clock: Clock, battery: BatteryCharging, activity: Activity,
};
const factorIcons = {
    coffee: Coffee, smartphone: Smartphone, dumbbell: Dumbbell,
};

export default function Dashboard() {
    return (
        <div className="app-layout">
            <Sidebar />

            <main className="page">
                <Header title="Огляд за тиждень" />

                <div className="dashboard">
                    {/* Stat cards */}
                    <div className="stats-grid">
                        {sleepStats.map((s) => {
                            const Icon = statIcons[s.icon];
                            return (
                                <div className="stat-card" key={s.label}>
                                    <div className="stat-card__top">
                                        <span className="stat-card__label">{s.label}</span>
                                        <div className="stat-card__icon">
                                            <Icon size={18} />
                                        </div>
                                    </div>
                                    <div className="stat-card__value">{s.value}</div>
                                    <div className="stat-card__sub">{s.sub}</div>
                                </div>
                            );
                        })}
                    </div>

                    <div className="dashboard__grid">
                        {/* Left column */}
                        <div className="dashboard__main">
                            {/* Sleep phases */}
                            <div className="panel">
                                <div className="panel__head">
                                    <div>
                                        <h3>Фази сну за тиждень</h3>
                                        <p>
                                            Співвідношення глибокого, швидкого та легкого сну
                                        </p>
                                    </div>
                                    <div className="legend">
                                        <span><i className="dot dot--deep" />Глибокий</span>
                                        <span><i className="dot dot--rem" />Швидкий</span>
                                        <span><i className="dot dot--light" />Легкий</span>
                                    </div>
                                </div>
                                <ResponsiveContainer width="100%" height={240}>
                                    <BarChart data={sleepPhases} barCategoryGap="28%">
                                        <CartesianGrid vertical={false} stroke="#18243d" />
                                        <XAxis
                                            dataKey="day"
                                            tickLine={false}
                                            axisLine={false}
                                            tick={{ fill: "#b7c1d9", fontSize: 12 }}
                                        />
                                        <YAxis
                                            tickLine={false}
                                            axisLine={false}
                                            tick={{ fill: "#b7c1d9", fontSize: 12 }}
                                            width={28}
                                        />
                                        <Bar dataKey="deep" stackId="a" fill="#2a3a63" />
                                        <Bar dataKey="rem" stackId="a" fill="#4da8ff" />
                                        <Bar
                                            dataKey="light"
                                            stackId="a"
                                            fill="#7c5cff"
                                            radius={[6, 6, 0, 0]}
                                        />
                                    </BarChart>
                                </ResponsiveContainer>
                            </div>

                            {/* Recovery */}
                            <div className="panel">
                                <div className="panel__head">
                                    <div>
                                        <h3>Рівень відновлення</h3>
                                        <p>Динаміка вашої енергії протягом дня</p>
                                    </div>
                                </div>
                                <ResponsiveContainer width="100%" height={220}>
                                    <AreaChart data={recoveryData}>
                                        <defs>
                                            <linearGradient id="rec" x1="0" y1="0" x2="0" y2="1">
                                                <stop offset="0%" stopColor="#34d399" stopOpacity={0.4} />
                                                <stop offset="100%" stopColor="#34d399" stopOpacity={0} />
                                            </linearGradient>
                                        </defs>
                                        <CartesianGrid vertical={false} stroke="#18243d" />
                                        <XAxis
                                            dataKey="time"
                                            tickLine={false}
                                            axisLine={false}
                                            tick={{ fill: "#b7c1d9", fontSize: 12 }}
                                        />
                                        <YAxis
                                            tickLine={false}
                                            axisLine={false}
                                            tick={{ fill: "#b7c1d9", fontSize: 12 }}
                                            width={28}
                                        />
                                        <Area
                                            type="monotone"
                                            dataKey="value"
                                            stroke="#34d399"
                                            strokeWidth={2}
                                            fill="url(#rec)"
                                        />
                                    </AreaChart>
                                </ResponsiveContainer>
                            </div>
                        </div>

                        {/* Right column */}
                        <div className="dashboard__side">
                            <div className="panel">
                                <div className="ai-head">
                                    <div className="ai-head__icon">
                                        <Brain size={18} />
                                    </div>
                                    <h3>ШІ-Асистент</h3>
                                </div>
                                <div className="ai-insights">
                                    {aiInsights.map((text, i) => (
                                        <div className="ai-insight" key={i}>
                                            {text}
                                        </div>
                                    ))}
                                </div>
                                <button className="ai-report">
                                    Згенерувати повний звіт
                                </button>
                            </div>

                            <div className="panel">
                                <h3 className="panel__title">Поведінкові фактори</h3>
                                <div className="factors">
                                    {behaviorFactors.map((f) => {
                                        const Icon = factorIcons[f.icon];
                                        return (
                                            <div className="factor" key={f.title}>
                                                <div className="factor__icon">
                                                    <Icon size={18} />
                                                </div>
                                                <div className="factor__text">
                                                    <span className="factor__title">
                                                        {f.title}
                                                    </span>
                                                    <span className="factor__note">
                                                        {f.note}
                                                    </span>
                                                </div>
                                                <i
                                                    className={`factor__status factor__status--${f.status}`}
                                                />
                                            </div>
                                        );
                                    })}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    );
}
