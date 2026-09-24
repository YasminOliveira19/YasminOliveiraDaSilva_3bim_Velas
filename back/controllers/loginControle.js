const { query } = require('../database');


exports.login = async (req, res) => {

    try {

        const { cpf_pessoa, senha_pessoa } = req.body;


        if (!cpf_pessoa || !senha_pessoa) {

            return res.status(400).json({
                sucesso: false,
                mensagem: 'Informe o CPF e a senha.'
            });

        }


        const result = await query(`
            SELECT
                p.cpf_pessoa,
                p.nome_pessoa,
                c.nome_cargo
            FROM pessoa p
            INNER JOIN funcionario f
                ON f.pessoa_cpf_pessoa = p.cpf_pessoa
            INNER JOIN cargo c
                ON c.id_cargo = f.cargo_id_cargo
            WHERE p.cpf_pessoa = $1
            AND p.senha_pessoa = $2
        `, [cpf_pessoa, senha_pessoa]);


        if (result.rows.length === 0) {

            return res.status(401).json({
                sucesso: false,
                mensagem: 'CPF, senha ou permissão inválidos.'
            });

        }


        const funcionario = result.rows[0];


        res.json({
            sucesso: true,
            mensagem: 'Login realizado com sucesso!',
            funcionario: funcionario
        });


    } catch (error) {

        console.error('Erro ao realizar login:', error);

        res.status(500).json({
            sucesso: false,
            mensagem: 'Erro interno do servidor.'
        });

    }

};