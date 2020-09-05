function connect()
    DBConnection = dbConnect("mysql", "dbname=mta;host=localhost;charset=utf8", "root", "root")
    if (not DBConnection) then
        outputDebugString("Error: Failed to establish connection to the MySQL database server")
    else
        outputDebugString("Success: Connected to the MySQL database server")
    end
end

addEventHandler("onResourceStart", resourceRoot, connect)
 
function query(...)
    local queryHandle = dbQuery(DBConnection, ...)
    if (not queryHandle) then
        return nil
    end
    local rows = dbPoll(queryHandle, -1)
    return rows
end
 
function execute(...)
    local queryHandle = dbQuery(DBConnection, ...)
    local result, numRows = dbPoll(queryHandle, -1)
    return numRows
end

function getDBConnection()
    return DBConnection
end

function validateAccount (player, command, ...)
	local arguments = {...}
	local getID = 188
	local query = dbQuery(DBConnection, "SELECT * FROM users WHERE code=?", arguments[1]) 
	local result, numrows, errmsg = dbPoll(query, -1) 
	if arguments[1] then
		if string.len(arguments[1]) == 6 then 
			if numrows > 0 then
				for result, row in pairs ( result ) do 
					for column, value in pairs ( row ) do  
					end 
					textOutput = "[BMA] ".. row["username"] ..", sua conta foi verificada com sucesso!"
					dbQuery(DBConnection, "UPDATE users SET code_status = '1', mta_id='".. getID .."' WHERE code=?", arguments[1])
					if row["code_status"] == 1 then
						textOutput = "[BMA] Esta conta já foi verificada!"
					end
				end
			else
				textOutput = "[BMA] Este código não existe!"
			end
		else
			textOutput = "[BMA] O código precisa ter 6 dígitos!"
		end
	else
		textOutput = "[BMA] Use /verificar código para verificar sua conta!"
	end
	outputChatBox("#ff0000".. textOutput .."", Player, 0, 255, 0, true)
end
addCommandHandler ("verificar", validateAccount)