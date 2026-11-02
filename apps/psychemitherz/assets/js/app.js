function initializeMobileMenu() {
  const header = document.getElementById("header");
  const openButton = document.querySelector("button.mobile-menu-button-open");
  const closeButton = document.querySelector("button.mobile-menu-button-close");
  const menu = document.getElementById("mobile-menu");
  const menuIconPath = openButton?.querySelector("path");

  if (!header || !openButton || !closeButton || !menu || !menuIconPath) {
    return;
  }

  const focusableSelector = 'a[href], button:not([disabled]), [tabindex]:not([tabindex="-1"])';

  function closeMenu() {
    header.style.height = "auto";
    menu.classList.add("hidden");
    menu.setAttribute("aria-hidden", "true");
    header.classList.remove("!bg-creme");
    openButton.setAttribute("aria-expanded", "false");
    closeButton.setAttribute("aria-expanded", "false");
    menuIconPath.setAttribute("d", "M2 6h20M2 12h20M2 18h20");
    openButton.focus();
  }

  function openMenu() {
    header.style.height = "100vh";
    menu.classList.remove("hidden");
    menu.removeAttribute("aria-hidden");
    header.classList.add("!bg-creme");
    openButton.setAttribute("aria-expanded", "true");
    closeButton.setAttribute("aria-expanded", "true");
    menuIconPath.setAttribute("d", "M4 4L20 20M4 20L20 4");
    closeButton.focus();
  }

  openButton.addEventListener("click", openMenu);
  closeButton.addEventListener("click", closeMenu);

  menu.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
      event.preventDefault();
      closeMenu();
      return;
    }

    if (event.key !== "Tab") {
      return;
    }

    const focusableElements = menu.querySelectorAll(focusableSelector);
    const firstFocusable = focusableElements[0];
    const lastFocusable = focusableElements[focusableElements.length - 1];

    if (event.shiftKey && document.activeElement === firstFocusable) {
      event.preventDefault();
      lastFocusable.focus();
    } else if (!event.shiftKey && document.activeElement === lastFocusable) {
      event.preventDefault();
      firstFocusable.focus();
    }
  });
}

function initializeHomeHeader() {
  const headerInfo = document.getElementById("header-info");
  const headerBackground = document.getElementById("header-background");
  const headerInfoContainer = document.getElementById("header-info-container");
  const headerInfoInContent = document.getElementById("header-info-in-content");

  if (!headerInfo || !headerBackground || !headerInfoContainer || !headerInfoInContent) {
    return;
  }

  const showHeaderInfoThreshold =
    headerInfoInContent.getBoundingClientRect().bottom + window.scrollY;

  headerInfo.classList.add("opacity-0");
  headerBackground.classList.add("max-md:opacity-0");

  function checkScrollPosition() {
    if (window.scrollY > showHeaderInfoThreshold) {
      headerInfo.classList.remove("opacity-0");
      headerBackground.classList.remove("max-md:opacity-0");
    } else {
      headerInfo.classList.add("opacity-0");
      headerBackground.classList.add("max-md:opacity-0");
    }
  }

  window.addEventListener("load", () => {
    setTimeout(() => {
      headerInfo.classList.add("transition-opacity");
      headerInfo.classList.add("duration-300");
      headerBackground.classList.add("max-md:transition-opacity");
      headerBackground.classList.add("max-md:duration-300");
    }, 0);
  });

  checkScrollPosition();
  window.addEventListener("scroll", checkScrollPosition);
}

function initializePage() {
  initializeMobileMenu();
  initializeHomeHeader();
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initializePage);
} else {
  initializePage();
}
