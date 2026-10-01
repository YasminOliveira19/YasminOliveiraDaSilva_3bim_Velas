const URL_API = 'http://localhost:3001';

let oQueEstaFazendo = '';
let cliente = null;

bloquearAtributos(true);

async function inicializar() {
    await listar();
}


async function procurePorChavePrimaria(chave) {
    try {
        const resposta = await fetch(`${URL_API}/cliente/${chave}`);
        const data = await resposta.json();
        return data.sucesso ? data.cliente : null;

    } catch (erro) {
        return null;
    }
}


async function procure() {
    const cpf_pessoa = document.getElementById("inputCPF_Pessoa").value;

    if (
        cpf_pessoa === "" ||
        cpf_pessoa.length !== 11 ||
        isNaN(cpf_pessoa)
    ) {
        mostrarAviso("Precisa ser um CPF válido!");
        return;
    }

    cliente = await procurePorChavePrimaria(cpf_pessoa);
    oQueEstaFazendo = '';
    if (cliente) {
        mostrarDadosCliente(cliente);
        visibilidadeDosBotoes(
            'inline',
            'none',
            'inline',
            'inline',
            'none'
        );
        mostrarAviso("Achou no banco, pode alterar ou excluir");

    } else {
        limparAtributos();
        document.getElementById("inputCPF_Pessoa").value = cpf_pessoa;
        visibilidadeDosBotoes(
            'inline',
            'inline',
            'none',
            'none',
            'none'
        );
        mostrarAviso("Não achou no banco, pode inserir");
    }
}


function inserir() {
    bloquearAtributos(false);
    // O CPF será usado para procurar/inserir a pessoa
    document.getElementById("inputCPF_Pessoa").readOnly = true;
    visibilidadeDosBotoes(
        'none',
        'none',
        'none',
        'none',
        'inline'
    );
    oQueEstaFazendo = 'inserindo';
    mostrarAviso(
        "INSERINDO - Digite os dados da pessoa e clique em salvar"
    );
}


function alterar() {
    bloquearAtributos(false);
    // CPF não pode ser alterado
    // Senha não pode ser alterado
    document.getElementById("inputCPF_Pessoa").readOnly = true;
    document.getElementById("inputSenha_Pessoa").readOnly = true;
    visibilidadeDosBotoes(
        'none',
        'none',
        'none',
        'none',
        'inline'
    );
    oQueEstaFazendo = 'alterando';
    mostrarAviso(
        "ALTERANDO - Altere os dados e clique em salvar"
    );
}


function excluir() {
    bloquearAtributos(true);
    visibilidadeDosBotoes(
        'none',
        'none',
        'none',
        'none',
        'inline'
    );
    oQueEstaFazendo = 'excluindo';
    mostrarAviso(
        "EXCLUINDO - Clique em salvar para confirmar a exclusão"
    );
}


async function salvar() {
    const cpf_pessoa = document.getElementById("inputCPF_Pessoa").value;
    const nome_pessoa = document.getElementById("inputNome_Pessoa").value;
    const senha_pessoa = document.getElementById("inputSenha_Pessoa").value;
    const email_pessoa = document.getElementById("inputEmail_Pessoa").value;

    const dadosCliente = {
        cpf_pessoa,
        nome_pessoa,
        senha_pessoa,
        email_pessoa
    };


    try {

        if (oQueEstaFazendo === 'inserindo') {
            const resposta = await fetch(
                `${URL_API}/cliente`,
                {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(dadosCliente)
                }
            );

            const data = await resposta.json();
            if (!data.sucesso) {
                mostrarAviso(data.mensagem);
                return;
            }
            mostrarAviso(
                "Cliente inserido no Banco de Dados com sucesso!"
            );
        }


        else if (oQueEstaFazendo === 'alterando') {
            const resposta = await fetch(
                `${URL_API}/cliente/${cpf_pessoa}`,
                {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(dadosCliente)
                }
            );

            const data = await resposta.json();
            if (!data.sucesso) {
                mostrarAviso(data.mensagem);
                return;
            }
            mostrarAviso(
                "Cliente alterado no Banco de Dados com sucesso!"
            );
        }


        else if (oQueEstaFazendo === 'excluindo') {
            const resposta = await fetch(
                `${URL_API}/cliente/${cpf_pessoa}`,
                {
                    method: 'DELETE'
                }
            );

            const data = await resposta.json();
            if (!data.sucesso) {
                mostrarAviso(data.mensagem);
                return;
            }
            mostrarAviso(
                "Cliente excluído do Banco de Dados!"
            );
        }

        visibilidadeDosBotoes(
            'inline',
            'none',
            'none',
            'none',
            'none'
        );
        limparAtributos();
        document.getElementById("inputCPF_Pessoa").value = "";

        listar();
    } catch (erro) {
        console.error(erro);
        mostrarAviso(
            "Erro ao efetuar operação no servidor."
        );
    }
}


async function listar() {

    try {
        const resposta =
            await fetch(`${URL_API}/cliente/listar`);

        const data = await resposta.json();

        if (data.sucesso) {
            let texto = "";
            for (let linha of data.clientes) {

                texto += `
                    ${linha.cpf_pessoa} -
                    ${linha.nome_pessoa} -
                    ${linha.email_pessoa}
                    <br>
                `;
            }
            document.getElementById("outputSaida").innerHTML = texto || "Nenhum cliente cadastrado.";

        } else {
            document.getElementById("outputSaida").innerHTML = data.mensagem;
        }

    } catch (erro) {
        document.getElementById("outputSaida").innerHTML = "Servidor offline.";
    }
}


function cancelarOperacao() {
    limparAtributos();
    bloquearAtributos(true);
    visibilidadeDosBotoes(
        'inline',
        'none',
        'none',
        'none',
        'none'
    );
    mostrarAviso("Cancelou a operação");
}


function mostrarAviso(mensagem) {
    document.getElementById("divAviso").innerHTML = mensagem;
}


function mostrarDadosCliente(p) {
    document.getElementById("inputCPF_Pessoa").value = p.cpf_pessoa;
    document.getElementById("inputNome_Pessoa").value = p.nome_pessoa;
    document.getElementById("inputSenha_Pessoa").value = p.senha_pessoa;
    document.getElementById("inputEmail_Pessoa").value = p.email_pessoa;
    bloquearAtributos(true);
}


function limparAtributos() {
    cliente = null;
    oQueEstaFazendo = '';
    document.getElementById("inputNome_Pessoa").value = "";
    document.getElementById("inputSenha_Pessoa").value = "";
    document.getElementById("inputEmail_Pessoa").value = "";
    bloquearAtributos(true);
}


function bloquearAtributos(soLeitura) {
    document.getElementById("inputCPF_Pessoa").readOnly = !soLeitura;
    document.getElementById("inputNome_Pessoa").readOnly = soLeitura;
    document.getElementById("inputSenha_Pessoa").readOnly = soLeitura;
    document.getElementById("inputEmail_Pessoa").readOnly = soLeitura;
}


function visibilidadeDosBotoes(btP, btI, btA, btE, btS) {
    document.getElementById("btProcure").style.display = btP;
    document.getElementById("btInserir").style.display = btI;
    document.getElementById("btAlterar").style.display = btA;
    document.getElementById("btExcluir").style.display = btE;
    document.getElementById("btSalvar").style.display = btS;
    document.getElementById("btCancelar").style.display = btS;
}