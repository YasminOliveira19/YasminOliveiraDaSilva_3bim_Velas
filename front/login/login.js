const URL_API = 'http://localhost:3001';


async function entrar() {
    const cpf_pessoa = document.getElementById("inputCPF_Pessoa").value;
    const senha_pessoa = document.getElementById("inputSenha_Pessoa").value;

    if (cpf_pessoa === "" || senha_pessoa === "") {
        mostrarAviso("Informe o CPF e a senha.");
        return;
    }

    if (cpf_pessoa.length !== 11 || isNaN(cpf_pessoa)) {
        mostrarAviso("Informe um CPF válido.");
        return;
    }


    try {

        const resposta = await fetch(`${URL_API}/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },

            body: JSON.stringify({
                cpf_pessoa,
                senha_pessoa
            })
        });

        const data = await resposta.json();
        if (!data.sucesso) {
            mostrarAviso(data.mensagem);
            return;
        }
        mostrarAviso("Login realizado com sucesso!");
        window.location.href = "../produto/produtos.html";


    } catch (erro) {
        console.error(erro);
        mostrarAviso(
            "Erro ao conectar com o servidor."
        );
    }
}


function mostrarAviso(mensagem) {
    document.getElementById("divAviso").innerHTML = mensagem;

}