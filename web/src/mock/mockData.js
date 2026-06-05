export const habits = [
    {
        id: 1,
        title: "Ранкова прогулянка",
        description: "15 хвилин на свіжому повітрі після пробудження",
        icon: "🚶",
        color: "green",
        streak: 7,
        days: [true, true, true, true, true, true, true],
    },
];

export const sleepStats = [
    { label: "Оцінка сну", value: "85", sub: "+2 від вчора", icon: "score" },
    { label: "Тривалість", value: "7г 42хв", sub: "Оптимально", icon: "clock" },
    { label: "Відновлення", value: "92%", sub: "Готовність до тренувань", icon: "battery" },
    { label: "Дефіцит сну", value: "0г 30хв", sub: "-1г за тиждень", icon: "activity" },
];

export const sleepPhases = [
    { day: "Пн", deep: 2.2, rem: 2.0, light: 1.6 },
    { day: "Вто", deep: 2.0, rem: 1.8, light: 1.4 },
    { day: "Сер", deep: 2.6, rem: 2.2, light: 1.8 },
    { day: "Чт", deep: 2.1, rem: 1.9, light: 1.5 },
    { day: "Пт", deep: 1.8, rem: 1.6, light: 1.3 },
    { day: "Сб", deep: 2.8, rem: 2.4, light: 2.0 },
    { day: "Нд", deep: 2.5, rem: 2.1, light: 1.7 },
];

export const recoveryData = [
    { time: "00:00", value: 28 },
    { time: "04:00", value: 35 },
    { time: "08:00", value: 80 },
    { time: "12:00", value: 72 },
    { time: "16:00", value: 60 },
    { time: "20:00", value: 45 },
    { time: "23:59", value: 30 },
];

export const aiInsights = [
    "Ваш циркадний ритм стабілізувався. Глибокий сон зріс завдяки регулярному відходу до сну до 22:30.",
    "Високий рівень стресу вчора ввечері призвів до затримки фази REM. Рекомендуємо: 15 хвилин медитації або читання перед сном сьогодні.",
];

export const behaviorFactors = [
    { title: "Кофеїн", note: "Останній келих: 14:30", status: "good", icon: "coffee" },
    { title: "Екранний час", note: "Перед сном: 45 хв", status: "bad", icon: "smartphone" },
    { title: "Активність", note: "Тренування: 18:00", status: "good", icon: "dumbbell" },
];
