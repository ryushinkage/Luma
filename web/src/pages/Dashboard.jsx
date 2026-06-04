import Sidebar from "../components/Sidebar";
import Header from "../components/Header";

export default function Dashboard() {
    return (
        <div className="app-layout">
            <Sidebar />

            <main className="page">
                <Header title="Огляд за тиждень" />

                <div className="dashboard">
                    <h1>Dashboard</h1>
                </div>
            </main>
        </div>
    );
}