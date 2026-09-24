const { query } = require('../database');


exports.listarCategorias = async (req, res) => {
  try {
    const result = await query('SELECT * FROM categoria ORDER BY id_categoria');
  //  console.log('Resultado do SELECT:', result.rows);
    res.json({ sucesso: true, categorias: result.rows });
  } catch (error) {
    console.error('Erro ao listar categorias:', error);
    res.status(500).json({ sucesso: false, mensagem: 'Erro interno do servidor' });
  }
};

exports.criarCategoria = async (req, res) => {
  try {
    const { id_categoria, nome_categoria } = req.body;

    // Validação básica
    if (!nome_categoria) {
      return res.status(400).json({
        sucesso: false,
        mensagem: 'O nome da categoria é obrigatório'
      });
    }

    const result = await query(
      'INSERT INTO categoria (id_categoria, nome_categoria) VALUES ($1, $2) RETURNING *',
      [id_categoria, nome_categoria]
    );

    res.status(201).json({ sucesso: true, categoria: result.rows[0] });
  } catch (error) {
    console.error('Erro ao criar categoria:', error);

    // Verifica se é erro de violação de constraint NOT NULL
    if (error.code === '23502') {
      return res.status(400).json({
        sucesso: false,
        mensagem: 'Dados obrigatórios não fornecidos'
      });
    }

    res.status(500).json({ sucesso: false, mensagem: 'Erro interno do servidor' });
  }
};

exports.obterCategoria = async (req, res) => {
  try {
    const id = parseInt(req.params.id);

    if (isNaN(id)) {
      return res.status(400).json({ sucesso: false, mensagem: 'ID deve ser um número válido' });
    }

    const result = await query(
      'SELECT * FROM categoria WHERE id_categoria = $1',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ sucesso: false, mensagem: 'Categoria não encontrado' });
    }

    res.json({ sucesso: true, categoria: result.rows[0] });
  } catch (error) {
    console.error('Erro ao obter categoria:', error);
    res.status(500).json({ sucesso: false, mensagem: 'Erro interno do servidor' });
  }
};

exports.atualizarCategoria = async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    const { nome_categoria } = req.body;

    // Verifica se o categoria existe
    const existingPersonResult = await query(
      'SELECT * FROM categoria WHERE id_categoria = $1',
      [id]
    );

    if (existingPersonResult.rows.length === 0) {
      return res.status(404).json({ sucesso: false, mensagem: 'Categoria não encontrado' });
    }

    // Constrói os campos para atualização
    const currentPerson = existingPersonResult.rows[0];
    const updatedFields = {
      nome_categoria: nome_categoria !== undefined ? nome_categoria : currentPerson.nome_categoria
    };

    // Atualiza o categoria
    const updateResult = await query(
      'UPDATE categoria SET nome_categoria = $1 WHERE id_categoria = $2 RETURNING *',
      [updatedFields.nome_categoria, id]
    );

    res.json({ sucesso: true, categoria: updateResult.rows[0] });
  } catch (error) {
    console.error('Erro ao atualizar categoria:', error);
    res.status(500).json({ sucesso: false, mensagem: 'Erro interno do servidor' });
  }
};

exports.deletarCategoria = async (req, res) => {
  try {
    const id = parseInt(req.params.id);

    // Verifica se o categoria existe
    const existingPersonResult = await query(
      'SELECT * FROM categoria WHERE id_categoria = $1',
      [id]
    );

    if (existingPersonResult.rows.length === 0) {
      return res.status(404).json({ sucesso: false, mensagem: 'Categoria não encontrado' });
    }

    // Deleta o categoria
    await query(
      'DELETE FROM categoria WHERE id_categoria = $1',
      [id]
    );

    res.json({ sucesso: true, mensagem: 'Categoria excluído com sucesso' });
  } catch (error) {
    console.error('Erro ao deletar categoria:', error);

    // Verifica se é erro de violação de foreign key (dependências)
    if (error.code === '23503') {
      return res.status(400).json({
        sucesso: false,
        mensagem: 'Não é possível deletar categoria com dependências associadas'
      });
    }

    res.status(500).json({ sucesso: false, mensagem: 'Erro interno do servidor' });
  }
};