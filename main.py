import tkinter as tk
from tkinter import ttk
from usuarios_tab import UsuariosTab

class UPlayApp:
    def __init__(self, root):
        self.root = root
        self.root.title("UPlay - Red Social de Videojuegos")
        self.root.geometry("1000x650")
        
        # Configurar tema moderno de ttk
        self.style = ttk.Style()
        self.style.theme_use('clam')
        
        # Contenedor de pestañas principal
        self.notebook = ttk.Notebook(root)
        self.notebook.pack(fill='both', expand=True, padx=10, pady=10)
        
        # 1. Pestaña de Usuarios (importada limpiamente desde su propio archivo)
        self.tab_usuarios = UsuariosTab(self.notebook)
        self.notebook.add(self.tab_usuarios, text="Gestión de Usuarios")
        
        # 2. Pestaña de Videojuegos (puedes modularizarla después de la misma forma)
        self.crear_pestana_videojuegos()

    def crear_pestana_videojuegos(self):
        pestana = ttk.Frame(self.notebook)
        self.notebook.add(pestana, text="Videojuegos")
        
        lbl = ttk.Label(pestana, text="Catálogo de Videojuegos y Contenido", font=("Arial", 14, "bold"))
        lbl.pack(pady=20)

if __name__ == "__main__":
    root = tk.Tk()
    app = UPlayApp(root)
    root.mainloop()