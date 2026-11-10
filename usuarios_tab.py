import tkinter as tk
from tkinter import ttk, messagebox
from conexion import crear_conexion

class UsuariosTab(ttk.Frame):
    def __init__(self, notebook):
        super().__init__(notebook)
        self.crear_widgets()
        self.cargar_datos_usuarios()

    def crear_widgets(self):
        # --- SECCIÓN IZQUIERDA: FORMULARIO DE REGISTRO SEGURO ---
        frame_form = ttk.LabelFrame(self, text=" Registro de Nuevo Usuario ")
        frame_form.pack(side="left", fill="y", padx=10, pady=10, ipadx=10, ipady=10)
        
        # Campos del formulario (¡Adiós al selector de roles por seguridad!)
        ttk.Label(frame_form, text="Nombre:").pack(anchor="w", pady=(5, 0))
        self.entry_nombre = ttk.Entry(frame_form, width=25)
        self.entry_nombre.pack(pady=(0, 5))
        
        ttk.Label(frame_form, text="Edad:").pack(anchor="w", pady=(5, 0))
        self.entry_edad = ttk.Entry(frame_form, width=25)
        self.entry_edad.pack(pady=(0, 5))
        
        ttk.Label(frame_form, text="Correo Electrónico:").pack(anchor="w", pady=(5, 0))
        self.entry_correo = ttk.Entry(frame_form, width=25)
        self.entry_correo.pack(pady=(0, 5))
        
        ttk.Label(frame_form, text="Contraseña (Hash):").pack(anchor="w", pady=(5, 0))
        self.entry_pass = ttk.Entry(frame_form, width=25, show="*")
        self.entry_pass.pack(pady=(0, 5))
        
        # El Estado por defecto también se fija en ACTIVO por seguridad
        ttk.Label(frame_form, text="Rol Asignado:").pack(anchor="w", pady=(5, 0))
        self.lbl_rol_info = ttk.Label(frame_form, text="USUARIO_APP (Por defecto)", font=("Arial", 9, "italic"), foreground="gray")
        self.lbl_rol_info.pack(anchor="w", pady=(0, 15))
        
        btn_registrar = ttk.Button(frame_form, text="Registrarse en UPlay", command=self.registrar_usuario)
        btn_registrar.pack(fill="x", pady=5)

        # --- SECCIÓN DERECHA: TABLA Y VISUALIZACIÓN ---
        frame_tabla = ttk.Frame(self)
        frame_tabla.pack(side="right", fill="both", expand=True, padx=10, pady=10)
        
        lbl_titulo = ttk.Label(frame_tabla, text="Usuarios Registrados en UPlay", font=("Arial", 14, "bold"))
        lbl_titulo.pack(pady=5)
        
        columnas = ("ID", "Nombre", "Edad", "Correo", "Rol", "Estado", "Registro")
        self.tabla_usuarios = ttk.Treeview(frame_tabla, columns=columnas, show='headings')
        
        anchos = [40, 120, 50, 150, 90, 80, 130]
        for col, ancho in zip(columnas, anchos):
            self.tabla_usuarios.heading(col, text=col)
            self.tabla_usuarios.column(col, width=ancho, anchor='center')
            
        self.tabla_usuarios.pack(fill='both', expand=True, pady=5)
        
        btn_cargar = ttk.Button(frame_tabla, text="Cargar / Refrescar Tabla desde MySQL", command=self.cargar_datos_usuarios)
        btn_cargar.pack(pady=5)

    def registrar_usuario(self):
        nombre = self.entry_nombre.get().strip()
        edad = self.entry_edad.get().strip()
        correo = self.entry_correo.get().strip()
        password = self.entry_pass.get().strip()
        
        # SEGURIDAD BACKEND: El rol y estado se imponen por código, el usuario no los elige
        rol_seguro = "USUARIO_APP"
        estado_seguro = "ACTIVO"

        if not nombre or not correo or not password:
            messagebox.showwarning("Campos incompletos", "Por favor completa Nombre, Correo y Contraseña.")
            return

        conexion = crear_conexion()
        if conexion:
            try:
                cursor = conexion.cursor()
                # La consulta inyecta los valores seguros directamente sin dejar opción al cliente
                query = """
                    INSERT INTO USUARIO (nombre, edad, correo_electronico, password_hash, ROL, estado) 
                    VALUES (%s, %s, %s, %s, %s, %s)
                """
                valores = (nombre, int(edad) if edad else None, correo, password, rol_seguro, estado_seguro)
                cursor.execute(query, valores)
                conexion.commit()
                
                messagebox.showinfo("Éxito", "¡Te has registrado correctamente en UPlay!")
                
                # Limpiar campos
                self.entry_nombre.delete(0, tk.END)
                self.entry_edad.delete(0, tk.END)
                self.entry_correo.delete(0, tk.END)
                self.entry_pass.delete(0, tk.END)
                
                # Refrescar tabla
                self.cargar_datos_usuarios()
            except Exception as e:
                messagebox.showerror("Error de Registro", f"No se pudo completar el registro:\n{e}")
            finally:
                cursor.close()
                conexion.close()

    def cargar_datos_usuarios(self):
        for item in self.tabla_usuarios.get_children():
            self.tabla_usuarios.delete(item)
            
        conexion = crear_conexion()
        if conexion:
            try:
                cursor = conexion.cursor()
                cursor.execute("SELECT ID_USUARIO, nombre, edad, correo_electronico, ROL, estado, fecha_registro FROM USUARIO")
                filas = cursor.fetchall()
                
                for fila in filas:
                    self.tabla_usuarios.insert('', 'end', values=fila)
            except Exception as e:
                messagebox.showerror("Error de Consulta", f"No se pudieron obtener los datos: {e}")
            finally:
                cursor.close()
                conexion.close()
