// Hamburger Menu Toggle
const hamburger = document.querySelector('.hamburger');
const navLinks = document.querySelector('.nav-links');

hamburger.addEventListener('click', function () {
    hamburger.classList.toggle('active');
    navLinks.classList.toggle('active');
});

// Close menu when a nav link is clicked
document.querySelectorAll('.nav-links a').forEach(link => {
    link.addEventListener('click', () => {
        hamburger.classList.remove('active');
        navLinks.classList.remove('active');
    });
});

// Sticky Navigation
window.addEventListener('scroll', function () {
    const navbar = document.getElementById('navbar');
    if (window.scrollY > 50) {
        navbar.classList.add('scrolled');
    } else {
        navbar.classList.remove('scrolled');
    }
});

// Smooth Scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();

        const targetId = this.getAttribute('href');
        if (targetId === '#') return;

        const targetElement = document.querySelector(targetId);
        if (targetElement) {
            // Adjust offset for fixed header
            const headerOffset = 80;
            const elementPosition = targetElement.getBoundingClientRect().top;
            const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

            window.scrollTo({
                top: offsetPosition,
                behavior: "smooth"
            });
        }
    });
});

// Initialize EmailJS
(function () {
    // REPLACE 'YOUR_PUBLIC_KEY' with your actual Public Key from EmailJS
    emailjs.init("5KBErsEjPjDncwLzp");
})();

// Form Submission handling - EmailJS
const contactForm = document.getElementById('contact-form');
if (contactForm) {
    contactForm.addEventListener('submit', function (e) {
        e.preventDefault();

        const btn = this.querySelector('button');
        const originalText = btn.innerText;

        // Visual Feedback
        btn.innerText = 'Sending Request...';
        btn.disabled = true;

        // Send via EmailJS
        emailjs.sendForm('service_mhirmr6', 'template_79wn5cl', this)
            .then(function () {
                btn.innerText = 'Consultation Requested!';
                btn.style.backgroundColor = '#1e3a8a';
                btn.style.color = 'white';
                contactForm.reset();

                setTimeout(() => {
                    btn.innerText = originalText;
                    btn.style.backgroundColor = '';
                    btn.style.color = '';
                    btn.disabled = false;
                }, 4000);
            }, function (error) {
                console.error('FAILED...', error);
                btn.innerText = 'Error! Try Again';
                btn.style.backgroundColor = '#ef4444';
                btn.disabled = false;

                setTimeout(() => {
                    btn.innerText = originalText;
                    btn.style.backgroundColor = '';
                }, 3000);
            });
    });
}
