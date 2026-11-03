CREATE TRIGGER archivar_nombres_historicos
AFTER UPDATE OF nombre_oficial ON EQUIPO
FOR EACH ROW
BEGIN 
    -- Si un club cambia su nombre oficial...
    IF :OLD.nombre_oficial != :NEW.nombre_oficial THEN
        -- insertamos el nombre antiguo en otros nombres.
        INSERT INTO EQUIPO_OTROS_NOMBRE (id_equipo, otro_nombre)
        VALUES (:NEW.nombre_oficial, :OLD.nombre_oficial);
    END IF;
END;