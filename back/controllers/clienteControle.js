const { query } = require('../database');

// Listar todos os clientes
exports.listarClientes = async (req, res) => {
    try {
        const result = await query(`
            SELECT
                p.cpf_pessoa,
                p.nome_pessoa,
                p.senha_pessoa,
                p.email_pessoa
            FROM cliente c
            INNER JOIN pessoa p
                ON p.cpf_pessoa = c.pessoa_cpf_pessoa
            ORDER BY p.cpf_pessoa
        `);

        res.json({
            sucesso: true,
            clientes: result.rows
        });

    } catch (error) {
        console.error('Erro ao listar clientes:', error);

        res.status(500).json({
            sucesso: false,
            mensagem: 'Erro ao listar clientes.'
        });
    }
};


// Procurar cliente pelo CPF
exports.obterCliente = async (req, res) => {
    try {
        const cpf = req.params.id;

        const result = await query(`
            SELECT
                p.cpf_pessoa,
                p.nome_pessoa,
                p.senha_pessoa,
                p.email_pessoa
            FROM cliente c
            INNER JOIN pessoa p
                ON p.cpf_pessoa = c.pessoa_cpf_pessoa
            WHERE p.cpf_pessoa = $1
        `, [cpf]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                sucesso: false,
                mensagem: 'Cliente não encontrado.'
            });
        }

        res.json({
            sucesso: true,
            cliente: result.rows[0]
        });

    } catch (error) {
        console.error('Erro ao obter cliente:', error);

        res.status(500).json({
            sucesso: false,
            mensagem: 'Erro interno do servidor.'
        });
    }
};


// Criar cliente
exports.criarCliente = async (req, res) => {
    try {
        const {
            cpf_pessoa,
            nome_pessoa,
            senha_pessoa,
            email_pessoa
        } = req.body;

        if (!cpf_pessoa || !nome_pessoa || !senha_pessoa || !email_pessoa) {
            return res.status(400).json({
                sucesso: false,
                mensagem: 'Todos os campos são obrigatórios.'
            });
        }

        // Primeiro cria a pessoa
        await query(`
            INSERT INTO pessoa (
                cpf_pessoa,
                nome_pessoa,
                senha_pessoa,
                email_pessoa
            )
            VALUES ($1, $2, $3, $4)
        `, [
            cpf_pessoa,
            nome_pessoa,
            senha_pessoa,
            email_pessoa
        ]);

        // Depois identifica essa pessoa como cliente
        const result = await query(`
            INSERT INTO cliente (pessoa_cpf_pessoa)
            VALUES ($1)
            RETURNING *
        `, [cpf_pessoa]);

        res.status(201).json({
            sucesso: true,
            mensagem: 'Cliente inserido com sucesso!',
            cliente: result.rows[0]
        });

    } catch (error) {
        console.error('Erro ao criar cliente:', error);

        res.status(500).json({
            sucesso: false,
            mensagem: 'Erro ao inserir cliente no banco de dados.'
        });
    }
};


// Alterar cliente
exports.atualizarCliente = async (req, res) => {
    try {
        const cpf = req.params.id;

        const {
            nome_pessoa,
            senha_pessoa,
            email_pessoa
        } = req.body;

        const result = await query(`
            UPDATE pessoa
            SET
                nome_pessoa = $1,
                senha_pessoa = $2,
                email_pessoa = $3
            WHERE cpf_pessoa = $4
            AND EXISTS (
                SELECT 1
                FROM cliente
                WHERE pessoa_cpf_pessoa = $4
            )
            RETURNING *
        `, [
            nome_pessoa,
            senha_pessoa,
            email_pessoa,
            cpf
        ]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                sucesso: false,
                mensagem: 'Cliente não encontrado.'
            });
        }

        res.json({
            sucesso: true,
            mensagem: 'Cliente alterado com sucesso!',
            cliente: result.rows[0]
        });

    } catch (error) {
        console.error('Erro ao atualizar cliente:', error);

        res.status(500).json({
            sucesso: false,
            mensagem: 'Erro ao atualizar cliente.'
        });
    }
};


// Excluir cliente
exports.deletarCliente = async (req, res) => {
    try {
        const cpf = req.params.id;

        await query(`
            DELETE FROM cliente
            WHERE pessoa_cpf_pessoa = $1
        `, [cpf]);

        res.json({
            sucesso: true,
            mensagem: 'Cliente excluído com sucesso!'
        });

    } catch (error) {
        console.error('Erro ao deletar cliente:', error);

        res.status(500).json({
            sucesso: false,
            mensagem: 'Erro ao excluir cliente.'
        });
    }
};