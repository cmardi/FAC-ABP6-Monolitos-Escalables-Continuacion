const API_URL = 'http://localhost:8080/api/productos';

// Elementos del DOM
const productForm = document.getElementById('product-form');
const productsList = document.getElementById('products-list');
const loading = document.getElementById('loading');
const noProducts = document.getElementById('no-products');
const formTitle = document.getElementById('form-title');
const submitBtn = document.getElementById('submit-btn');
const cancelBtn = document.getElementById('cancel-btn');

let editingProductId = null;

// Cargar productos al iniciar
document.addEventListener('DOMContentLoaded', loadProducts);

// Manejar envío del formulario
productForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const productData = {
        nombre: document.getElementById('nombre').value,
        precio: parseFloat(document.getElementById('precio').value)
    };

    try {
        if (editingProductId) {
            await updateProduct(editingProductId, productData);
        } else {
            await createProduct(productData);
        }
        resetForm();
        loadProducts();
    } catch (error) {
        alert('Error al guardar el producto: ' + error.message);
    }
});

// Cancelar edición
cancelBtn.addEventListener('click', resetForm);

// Cargar todos los productos
async function loadProducts() {
    try {
        loading.style.display = 'block';
        productsList.style.display = 'none';
        noProducts.style.display = 'none';

        const response = await fetch(API_URL);
        const products = await response.json();

        loading.style.display = 'none';
        
        if (products.length === 0) {
            noProducts.style.display = 'block';
            return;
        }

        productsList.style.display = 'block';
        productsList.innerHTML = '';

        products.forEach(product => {
            const productCard = document.createElement('div');
            productCard.className = 'product-card';
            productCard.innerHTML = `
                <div class="product-info">
                    <h3>${product.nombre}</h3>
                    <span class="price">$${product.precio.toFixed(2)}</span>
                </div>
                <div class="product-actions">
                    <button class="btn-edit" onclick="editProduct(${product.id}, '${product.nombre}', ${product.precio})">
                        ✏️ Editar
                    </button>
                    <button class="btn-delete" onclick="deleteProduct(${product.id})">
                        🗑️ Eliminar
                    </button>
                </div>
            `;
            productsList.appendChild(productCard);
        });

    } catch (error) {
        loading.style.display = 'none';
        noProducts.style.display = 'block';
        noProducts.innerHTML = 'Error al cargar los productos';
        console.error('Error:', error);
    }
}

// Crear nuevo producto
async function createProduct(productData) {
    const response = await fetch(API_URL, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(productData)
    });

    if (!response.ok) {
        throw new Error('Error al crear producto');
    }

    return response.json();
}

// Actualizar producto
async function updateProduct(id, productData) {
    const response = await fetch(`${API_URL}/${id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(productData)
    });

    if (!response.ok) {
        throw new Error('Error al actualizar producto');
    }

    return response.json();
}

// Eliminar producto
async function deleteProduct(id) {
    if (!confirm('¿Estás seguro de que quieres eliminar este producto?')) {
        return;
    }

    try {
        const response = await fetch(`${API_URL}/${id}`, {
            method: 'DELETE'
        });

        if (!response.ok) {
            throw new Error('Error al eliminar producto');
        }

        loadProducts();
    } catch (error) {
        alert('Error al eliminar el producto: ' + error.message);
    }
}

// Editar producto
function editProduct(id, nombre, precio) {
    editingProductId = id;
    document.getElementById('product-id').value = id;
    document.getElementById('nombre').value = nombre;
    document.getElementById('precio').value = precio;
    
    formTitle.textContent = '✏️ Editar Producto';
    submitBtn.textContent = 'Actualizar Producto';
    cancelBtn.style.display = 'inline-block';
    
    // Scroll al formulario
    productForm.scrollIntoView({ behavior: 'smooth' });
}

// Resetear formulario
function resetForm() {
    editingProductId = null;
    productForm.reset();
    document.getElementById('product-id').value = '';
    formTitle.textContent = '➕ Agregar Producto';
    submitBtn.textContent = 'Agregar Producto';
    cancelBtn.style.display = 'none';
}

// Agregar funciones al global scope para los botones
window.editProduct = editProduct;
window.deleteProduct = deleteProduct;