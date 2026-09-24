const express = require('express');
const multer = require('multer');
const router = express.Router();
const produtoControle = require('../controllers/produtoControle');

// Configura o Multer para armazenar em memória temporária para o Sharp processar
const upload = multer({ storage: multer.memoryStorage() });

// Rotas do CRUD de Produtos
router.get('/listar', produtoControle.listarProdutos);
router.get('/:id', produtoControle.obterProduto);
router.post('/', produtoControle.criarProduto);
router.put('/:id', produtoControle.atualizarProduto);
router.delete('/:id', produtoControle.deletarProduto);

// Rota para upload da imagem
router.post('/upload/:id', upload.single('imagem'), produtoControle.uploadImagem);

module.exports = router;