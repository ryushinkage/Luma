const API_URL = "http://localhost:5000/api";

export async function getHabits() {
    const res = await fetch(`${API_URL}/habits`);
    return res.json();
}

export async function getSleepStats() {
    const res = await fetch(`${API_URL}/sleep`);
    return res.json();
}