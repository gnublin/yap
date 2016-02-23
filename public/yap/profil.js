clickGenPassAdd();

function clickGenPassAdd() {
    var genPass = document.querySelector('.pass-gen-profil');
    if (genPass) {
        genPass.addEventListener('click',genPassword);
    }
}

