const listingMonths = {
  Jan: "1",
  Feb: "2",
  Mar: "3",
  Apr: "4",
  May: "5",
  Jun: "6",
  Jul: "7",
  Aug: "8",
  Sep: "9",
  Oct: "10",
  Nov: "11",
  Dec: "12"
};

function parseListingDate(text) {
  const match = text.match(/\b(\d{1,2})\s+([A-Za-z]{3})\s+(\d{4})\b/);
  if (!match) {
    return { month: "", year: "" };
  }

  return {
    month: listingMonths[match[2]] ?? "",
    year: match[3]
  };
}

function normalizeText(value) {
  return value.trim().toLowerCase();
}

document.querySelectorAll(".itemListing").forEach((listing) => {
  const uniqueId = listing.dataset.uniqueid;
  if (!uniqueId) {
    return;
  }

  const list = document.getElementById(`${uniqueId}-list`);
  if (!list) {
    return;
  }

  const items = Array.from(list.querySelectorAll("li.item"));
  if (!items.length) {
    return;
  }

  const monthField = document.getElementById(`${uniqueId}-Month`);
  const yearField = document.getElementById(`${uniqueId}-Year`);
  const keywordsField = document.getElementById(`${uniqueId}-Keywords`);
  const searchButton = document.getElementById(`${uniqueId}-search`);
  const wrapper = list.querySelector(".items-wrapper") ?? list;
  const emptyState = document.createElement("div");

  emptyState.className = "text-center py-4";
  emptyState.textContent = "No matching items found.";

  const runFilter = () => {
    const selectedMonth = monthField?.value ?? "";
    const selectedYear = yearField?.value ?? "";
    const keywords = normalizeText(keywordsField?.value ?? "");

    let visibleCount = 0;

    items.forEach((item) => {
      const dateParts = parseListingDate(item.textContent);
      const searchableText = normalizeText(item.textContent);
      const matchesMonth = !selectedMonth || dateParts.month === selectedMonth;
      const matchesYear = !selectedYear || dateParts.year === selectedYear;
      const matchesKeywords = !keywords || searchableText.includes(keywords);
      const isVisible = matchesMonth && matchesYear && matchesKeywords;

      item.style.display = isVisible ? "" : "none";
      if (isVisible) {
        visibleCount += 1;
      }
    });

    emptyState.remove();
    if (!visibleCount) {
      wrapper.appendChild(emptyState);
    }
  };

  searchButton?.addEventListener("click", runFilter);
  monthField?.addEventListener("change", runFilter);
  yearField?.addEventListener("change", runFilter);
  keywordsField?.addEventListener("keydown", (event) => {
    if (event.key === "Enter") {
      event.preventDefault();
      runFilter();
    }
  });
});
