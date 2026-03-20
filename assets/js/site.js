const body = document.body;
const navbarToggler = document.querySelector(".navbar-toggler");
const navTogglerIcon = document.querySelector(".navTogglerIcon");
const megaMenu = document.getElementById("megaMenu");
const mobileSearchTrigger = document.querySelector(".search-trigger-m");
const desktopSearchTrigger = document.querySelector(".search-trigger");
const searchBar = document.getElementById("searchBar");
const banner = document.getElementById("alertBanner");
const bannerClose = document.querySelector("[data-banner-close]");
const searchInput = document.getElementById("searchTextbox");
const searchButton = document.getElementById("searchButton");
const searchResults = document.getElementById("searchResults");
const backToTop = document.getElementById("backToTop");

const searchIndex = [
  { title: "Programme Overview", href: "#overview", keywords: ["overview", "what is", "programme", "about"] },
  { title: "Services at Home", href: "#services", keywords: ["services", "monitoring", "iv", "laboratory", "home visit"] },
  { title: "How It Works", href: "#how-it-works", keywords: ["journey", "how it works", "referral", "assessment"] },
  { title: "Why Choose NUHS@Home?", href: "#benefits", keywords: ["benefits", "cost", "subsidy", "why choose"] },
  { title: "Contact the Team", href: "#contact", keywords: ["contact", "email", "asknuhsathome", "facebook", "instagram"] },
  {
    title: "Official NUHS@Home Page",
    href: "patient-care/nuhs-at-home/",
    keywords: ["official", "website", "hub", "nuhs"]
  }
];

function isDesktop() {
  return window.innerWidth >= 992;
}

function closeMobileMenu() {
  megaMenu?.classList.remove("show");
  navbarToggler?.setAttribute("aria-expanded", "false");
  navTogglerIcon?.classList.remove("active");
  document.querySelectorAll(".m-dropdown-toggle").forEach((button) => {
    button.classList.remove("is-open");
    button.setAttribute("aria-expanded", "false");
  });
  document.querySelectorAll(".dropdown-menu").forEach((menu) => {
    menu.classList.remove("show");
  });
  document.querySelectorAll(".dropdown-open").forEach((item) => {
    item.classList.remove("dropdown-open");
  });
}

function toggleSearch() {
  if (!searchBar) {
    return;
  }

  const isOpen = searchBar.classList.toggle("show");
  [mobileSearchTrigger, desktopSearchTrigger].forEach((trigger) => {
    trigger?.setAttribute("aria-expanded", String(isOpen));
  });

  if (isOpen) {
    closeMobileMenu();
    searchInput?.focus();
  }
}

if (navbarToggler) {
  navbarToggler.addEventListener("click", () => {
    const isOpen = megaMenu.classList.toggle("show");
    navbarToggler.setAttribute("aria-expanded", String(isOpen));
    navTogglerIcon?.classList.toggle("active", isOpen);

    if (isOpen) {
      searchBar?.classList.remove("show");
      [mobileSearchTrigger, desktopSearchTrigger].forEach((trigger) => {
        trigger?.setAttribute("aria-expanded", "false");
      });
    }
  });
}

[mobileSearchTrigger, desktopSearchTrigger].forEach((trigger) => {
  trigger?.addEventListener("click", toggleSearch);
});

document.querySelectorAll(".m-dropdown-toggle").forEach((button) => {
  button.addEventListener("click", (event) => {
    event.preventDefault();
    event.stopPropagation();

    const navItem = button.closest(".nav-item");
    const menu = navItem?.querySelector(".dropdown-menu");
    const isOpen = menu?.classList.toggle("show");

    button.classList.toggle("is-open", Boolean(isOpen));
    button.setAttribute("aria-expanded", String(Boolean(isOpen)));
    navItem?.classList.toggle("dropdown-open", Boolean(isOpen));
  });
});

window.addEventListener("resize", () => {
  if (isDesktop()) {
    closeMobileMenu();
  }
});

const bannerStorageKey = "nuhsHomeBannerHidden";

if (localStorage.getItem(bannerStorageKey) === "true") {
  banner?.classList.remove("show");
}

bannerClose?.addEventListener("click", () => {
  banner?.classList.remove("show");
  localStorage.setItem(bannerStorageKey, "true");
});

function renderSearchResults(matches, query) {
  if (!searchResults) {
    return;
  }

  if (!query) {
    searchResults.innerHTML = "";
    return;
  }

  if (!matches.length) {
    searchResults.textContent = `No matches found for "${query}".`;
    return;
  }

  searchResults.innerHTML = matches
    .map((item) => `<a href="${item.href}">${item.title}</a>`)
    .join("");
}

function findSearchMatches(query) {
  const normalized = query.trim().toLowerCase();

  if (!normalized) {
    return [];
  }

  return searchIndex.filter((item) => {
    return item.title.toLowerCase().includes(normalized) || item.keywords.some((keyword) => keyword.includes(normalized));
  });
}

function runSearch() {
  const query = searchInput?.value ?? "";
  const matches = findSearchMatches(query);

  renderSearchResults(matches, query);

  if (!matches.length) {
    return;
  }

  const firstMatch = matches[0];
  if (firstMatch.href.startsWith("#")) {
    window.location.hash = firstMatch.href;
  } else {
    window.location.href = firstMatch.href;
  }
}

searchButton?.addEventListener("click", runSearch);

searchInput?.addEventListener("keydown", (event) => {
  if (event.key === "Enter") {
    event.preventDefault();
    runSearch();
  }
});

searchInput?.addEventListener("input", () => {
  const query = searchInput.value;
  renderSearchResults(findSearchMatches(query), query);
});

window.addEventListener("scroll", () => {
  if (!backToTop) {
    return;
  }

  if (window.scrollY > 100) {
    backToTop.style.display = "inline-flex";
  } else {
    backToTop.style.display = "none";
  }
});

backToTop?.addEventListener("click", () => {
  window.scrollTo({ top: 0, behavior: "smooth" });
});

document.querySelectorAll('.navbar-nav .nav-link[href^="#"], .search-shortcuts a[href^="#"], .help-card[href^="#"]').forEach((link) => {
  link.addEventListener("click", () => {
    if (!isDesktop()) {
      closeMobileMenu();
    }
  });
});
