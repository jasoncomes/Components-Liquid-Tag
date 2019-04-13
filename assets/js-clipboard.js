document.querySelectorAll(".js-clipboard").forEach((el) => {
  el.addEventListener("click", (ev) => {
    ev.preventDefault();
    ev.target
      .closest("code")
      .nextElementSibling.querySelector("textarea")
      .select();
    document.execCommand("copy");
  });
});
