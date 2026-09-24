const express = require('express');
const router = express.Router();
const clienteControle = require('../controllers/clienteControle');

// Rotas do CRUD de Clientes
router.get('/listar', clienteControle.listarClientes);
router.get('/:id', clienteControle.obterCliente);
router.post('/', clienteControle.criarCliente);
router.put('/:id', clienteControle.atualizarCliente);
router.delete('/:id', clienteControle.deletarCliente);

module.exports = router;