// --- Елементи вікна "Увійти" ---
const loginBtn = document.querySelector('.login-link'); 
const loginModal = document.getElementById('login-modal');
const closeLoginBtn = document.getElementById('close-modal');

// --- Елементи вікна "Реєстрація" ---
// Збираємо всі кнопки з класом 'open-register'
const registerBtns = document.querySelectorAll('.open-register'); 
const registerModal = document.getElementById('register-modal');
const closeRegisterBtn = document.getElementById('close-register');

// --- Кнопки перемикання між вікнами ---
const switchToRegister = document.getElementById('switch-to-register');
const switchToLogin = document.getElementById('switch-to-login');

// --- ФУНКЦІЇ ВІДКРИТТЯ/ЗАКРИТТЯ ---
function openModal(modal) {
    modal.classList.add('active');
    document.body.style.overflow = 'hidden';
}

function closeModal(modal) {
    modal.classList.remove('active');
    document.body.style.overflow = 'auto';
}

// --- ЛОГІКА: ВХІД ---
// Відкрити
loginBtn.addEventListener('click', (e) => {
    e.preventDefault();
    openModal(loginModal);
});
// Закрити на хрестик
closeLoginBtn.addEventListener('click', () => closeModal(loginModal));
// Закрити по кліку на фон
loginModal.addEventListener('click', (e) => {
    if (e.target === loginModal) closeModal(loginModal);
});

// --- ЛОГІКА: РЕЄСТРАЦІЯ ---
// Оскільки кнопок "Почати безкоштовно" декілька, вішаємо клік на кожну
registerBtns.forEach(btn => {
    btn.addEventListener('click', (e) => {
        e.preventDefault();
        openModal(registerModal);
    });
});
// Закрити на хрестик
closeRegisterBtn.addEventListener('click', () => closeModal(registerModal));
// Закрити по кліку на фон
registerModal.addEventListener('click', (e) => {
    if (e.target === registerModal) closeModal(registerModal);
});

// --- ЛОГІКА: ПЕРЕМИКАННЯ МІЖ ВІКНАМИ ---
// З логіна на реєстрацію
if (switchToRegister) {
    switchToRegister.addEventListener('click', (e) => {
        e.preventDefault();
        closeModal(loginModal);
        openModal(registerModal);
    });
}

// З реєстрації на логін
if (switchToLogin) {
    switchToLogin.addEventListener('click', (e) => {
        e.preventDefault();
        closeModal(registerModal);
        openModal(loginModal);
    });
}
// --- ЛОГІКА ПЕРЕХОДУ НА ДАШБОРД ---
// Знаходимо форму логіну та форму реєстрації
const forms = document.querySelectorAll('.login-form');

forms.forEach(form => {
    form.addEventListener('submit', (e) => {
        e.preventDefault(); // Зупиняємо стандартну перезагрузку сторінки
        
        // Тут зазвичай роблять перевірку пароля чи відправку на сервер.
        // Але оскільки ми робимо прототип, просто перекидаємо користувача на дашборд:
        window.location.href = 'dashboard.html';
    });
});