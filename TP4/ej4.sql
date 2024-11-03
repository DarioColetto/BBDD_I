-- Crear tabla TareasAsignadas
-- Crear tabla Empleados
DROP TABLE IF EXISTS TareasAsignadas;
DROP TABLE IF EXISTS Tareas;
DROP TABLE IF EXISTS Empleados;

CREATE TABLE Empleados (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Departamento VARCHAR(50) NOT NULL,
    TareasPendientes INT DEFAULT 0
);

-- Crear tabla Tareas

CREATE TABLE Tareas (
    TareaId INTEGER PRIMARY KEY AUTO_INCREMENT,
    Descripcion VARCHAR(255) NOT NULL,
    Prioridad INT NOT NULL 
);

CREATE TABLE TareasAsignadas (
    AsignacionId INTEGER PRIMARY KEY AUTO_INCREMENT,
    EmpleadoId INT,
    TareaId INT,
    FechaAsignacion DATE,
    FOREIGN KEY (EmpleadoId) REFERENCES Empleados(Id),
    FOREIGN KEY (TareaId) REFERENCES Tareas(TareaId)
);

-- Insertar datos en Empleados
INSERT INTO Empleados (Nombre, Departamento, TareasPendientes) VALUES
('Empleado1', 'Ventas', 2),
('Empleado2', 'Ventas', 0),
('Empleado3', 'Marketing', 5),
('Empleado4', 'Marketing', 1);

-- Insertar datos en Tareas
INSERT INTO Tareas (Descripcion, Prioridad) VALUES
('Tarea 1', 1),
('Tarea 2', 2),
('Tarea 3', 3),
('Tarea 4', 1),
('Tarea 5', 2);




DELIMITER//
BEGIN
  DECLARE v_done INT DEFAULT FALSE;
  DECLARE v_tareaId INT;
  DECLARE v_descripcionTarea VARCHAR(255);
  DECLARE v_prioridadTarea INT;
  DECLARE v_empleadoId INT;

  -- Cursor --
  DECLARE cur CURSOR FOR 
    SELECT TareaId, Descripcion, Prioridad
    FROM Tareas
    ORDER BY Prioridad ASC;

  -- Handler para finalizar el cursor--
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

  --  Comienzo de transaction
  START TRANSACTION;

  -- Abre cursor
  OPEN cur;

  read_loop: LOOP
    -- Fetch 
    FETCH cur INTO v_tareaId, v_descripcionTarea, v_prioridadTarea;

    -- Sale del loop si no hay maas tareas
    IF v_done THEN
      LEAVE read_loop;
    END IF;

    -- Select del empleado con menos tareas
    SELECT Id INTO v_empleadoId
    FROM Empleados
    ORDER BY TareasPendientes ASC, Id ASC
    LIMIT 1;

    -- Chek si el empleado no tiene tareas o es null
    IF v_empleadoId IS NOT NULL AND v_tareaId IS NOT NULL THEN
        -- Insert the assigned task with the current date
        INSERT INTO TareasAsignadas (EmpleadoId, TareaId, FechaAsignacion) 
        VALUES (v_empleadoId, v_tareaId, CURDATE());

        -- Increment the employee's pending task counter
        UPDATE Empleados 
        SET TareasPendientes = TareasPendientes + 1 
        WHERE Id = v_empleadoId;
    END IF;
  END LOOP;

  -- Close the cursor
  CLOSE cur;

  -- Commit transaction
  COMMIT;
END


DELIMITER