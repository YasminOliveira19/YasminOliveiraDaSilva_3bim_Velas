const express = require('express');
const router = express.Router();
const categoriaControle = require('../controllers/categoriaControle');

// Rotas do CRUD de Categorias
router.get('/listar', categoriaControle.listarCategorias);
router.get('/:id', categoriaControle.obterCategoria);
router.post('/', categoriaControle.criarCategoria);
router.put('/:id', categoriaControle.atualizarCategoria);
router.delete('/:id', categoriaControle.deletarCategoria);

module.exports = router;