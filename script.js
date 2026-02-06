emailjs.init("Rrg43rfmXNfFOgyyF");

const form = document.querySelector("form");
const footer = document.querySelector("footer");

form.addEventListener("submit", function (e) {
  e.preventDefault();

  const name = document.querySelector("#name").value;
  const message = document.querySelector("#message").value;

  const oldMsg = document.querySelector(".form-message");
  if (oldMsg) oldMsg.remove();

  const msgDiv = document.createElement("div");
  msgDiv.classList.add("form-message");
  msgDiv.style.marginTop = "10px";
  msgDiv.style.color = "#d38fff";
  msgDiv.style.textAlign = "center";
  msgDiv.style.fontWeight = "bold";
  msgDiv.style.textShadow = "0 0 5px #a000ff";

  if (name === "" || message === "") {
    msgDiv.textContent = "❌ Veuillez remplir tous les champs !";
  } else {
    const templateParams = { name: name, message: message };

    emailjs.send("service_2289lqi", "template_r1mthyx", templateParams).then(
      function (response) {
        msgDiv.textContent = `✅ Merci ${name} ! Votre message a été reçu.`;
        form.reset();
      },
      function (error) {
        msgDiv.textContent = "❌ Erreur : le message n'a pas pu être envoyé.";
        console.log(error);
      },
    );
  }

  footer.appendChild(msgDiv);
  msgDiv.classList.add("neon-animated");
});
