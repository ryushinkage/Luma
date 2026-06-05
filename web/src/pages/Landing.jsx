import { Link } from "react-router-dom";
import { Moon, Sparkles, Play, Brain, Activity, Target } from "lucide-react";

export default function Landing() {
    return (
        <main className="landing">
            <header className="landing-header">
                <div className="landing-header__logo">
                    <div className="landing-header__icon">
                        <Moon size={18} />
                    </div>

                    <span>SleepAnalytics</span>
                </div>

                <nav className="landing-header__nav">
                    <a href="#">Можливості</a>
                    <a href="#">Аналітика</a>
                    <a href="#">Відгуки</a>
                    <a href="#">Ціни</a>
                </nav>

                <div className="landing-header__actions">
                    <button className="landing-header__login">Увійти</button>
                    <Link to="/dashboard" className="landing-header__cta">
                        Спробувати
                    </Link>
                </div>
                
            </header>
            <section className="hero">
                <div className="hero__glow hero__glow--purple" />
                <div className="hero__glow hero__glow--blue" />

                <div className="hero__content">
                    <div className="hero__left">
                        <div className="badge">
                            <Sparkles size={16} />
                            <span>Нове: ШІ-коучинг сну</span>
                        </div>

                        <h1>
                            Спіть краще.
                            <span>Відновлюйтесь</span>
                            <span>розумніше.</span>
                        </h1>

                        <p>
                            Перша інтелектуальна платформа, яка аналізує якість вашого сну,
                            відстежує довгострокові тренди та надає персоналізовані
                            ШІ-рекомендації.
                        </p>

                        <div className="hero__actions">
                            <Link to="/dashboard" className="btn btn--light">
                                Почати безкоштовно
                            </Link>

                            <button className="btn btn--dark">
                                Дивитись демо
                                <Play size={16} />
                            </button>
                        </div>
                    </div>

                    <div className="hero__card">
                        <div className="hero__card-header">
                            <div>
                                <p>Оцінка сну</p>
                                <h3>85 /100</h3>
                            </div>

                            <div>
                                <p>Час сну</p>
                                <h3>7г 42хв</h3>
                            </div>
                        </div>

                        <div className="sleep-bars">
                            {[70, 55, 78, 88, 62, 92, 80].map((height, index) => (
                                <div className="sleep-bars__item" key={index}>
                                    <span style={{ height: `${height}%` }} />
                                </div>
                            ))}
                        </div>

                        <div className="ai-card">
                            <div className="ai-card__icon">
                                <Brain size={22} />
                            </div>

                            <div>
                                <h4>ШІ-Інсайт</h4>
                                <p>
                                    Ваш глибокий сон збільшився на 15% після того, як ви
                                    перестали вживати кофеїн після 14:00.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section className="features">
                <h2>Що робить платформа</h2>
                <p>
                    Повний набір інструментів для розуміння та покращення вашого сну.
                </p>

                <div className="features__grid">
                    <article>
                        <Activity size={28} />
                        <h3>Аналіз сну</h3>
                        <p>Детальне розбиття фаз сну: швидкий, глибокий та легкий сон.</p>
                    </article>

                    <article>
                        <Brain size={28} />
                        <h3>ШІ-інсайти</h3>
                        <p>Персоналізовані пояснення того, що впливає на якість сну.</p>
                    </article>

                    <article>
                        <Target size={28} />
                        <h3>Коучинг сну</h3>
                        <p>Адаптивні рекомендації для формування здорових звичок.</p>
                    </article>
                </div>
            </section>
        </main>
    );
}