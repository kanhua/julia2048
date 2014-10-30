module core2048X

export move, merge, moveMerge, boardMove, getLine, setLine, printBoard, initBoard, addTile


function move(line::Array{Int64,1},direction::Int64)
	lineLen=length(line)

	nonZeroLine=line[line.>0]
	nonZeroLineLength=length(nonZeroLine)

	if length(nonZeroLine)<lineLen
		if direction >0
			return [nonZeroLine,zeros(Int64,lineLen-nonZeroLineLength)]
		elseif direction < 0
			return [zeros(Int64,lineLen-nonZeroLineLength),nonZeroLine]
		end
	
	elseif nonZeroLineLength==lineLen

		return line
	end
end


function merge(line::Array{Int64,1},direction::Int64)

	addScore=0
	lineLen=length(line)
	if direction>0
		for idx=1:lineLen
			nextidx=idx+1;
			if nextidx<=lineLen
				if line[idx]==line[nextidx]

					addScore=addScore+line[idx]*2
					line[idx]=line[idx]*2
					line[nextidx]=0
				end

			end
		end
	elseif direction <0
		for idx=lineLen:-1:1
			nextidx=idx-1;
			if nextidx>=1
				if line[idx]==line[nextidx]

					addScore=addScore+line[idx]*2
					line[idx]=line[idx]*2
					line[nextidx]=0
				end

			end
		end
	end

	return addScore
end



function moveMergeZ(line::Array{Int64,1},direction::Int64)

	addScore=0
	line=move(line,direction)
	
	addScore=merge(line,direction)
	if addScore >0
		line=move(line,direction)
	end

	return line,addScore
end

function moveMerge(line::Array{Int64,1},direction::Int64)

	addScore=0
	lineLen=length(line)

	nonZeroLine=line[line.>0]

	nonZeroLineLength=length(nonZeroLine)

	if nonZeroLineLength ==0
		return line,addScore
	end

	if nonZeroLineLength>1
		addScore=merge(nonZeroLine,direction)
	end
	
	nonZeroLine=nonZeroLine[nonZeroLine.>0]

	if length(nonZeroLine)<lineLen
		if direction >0
			return [nonZeroLine,zeros(Int64,lineLen-nonZeroLineLength)],addScore
		elseif direction < 0
			return [zeros(Int64,lineLen-nonZeroLineLength),nonZeroLine],addScore
		end
	
	elseif nonZeroLineLength==lineLen

		return line,addScore
	end

end


function boardMove(board::Array{Int64,2},direction::Int64)

	newBoard=copy(board)
	addScore=0
	if abs(direction)==2
		line=zeros(Int64,size(board,1))
	elseif abs(direction)==1
		line=zeros(Int64,size(board,2))
	end
	for rowIdx=1:size(newBoard,abs(direction))
		getLine(newBoard,abs(direction),rowIdx,line)
		newLine,score=moveMerge(line,direction)
		addScore=addScore+score
		setLine(newBoard,abs(direction),rowIdx,newLine)
	end

	return newBoard,addScore
end


function getLine(board::Array{Int64,2},dim::Int64,index::Int64,line::Array{Int64,1})

	if dim==1
		
		line=board[index,:][:]

	elseif dim==2

		line=board[:,index][:]

	end

	nothing

end


function setLine(board::Array{Int64,2},dim::Int64,index::Int64,line::Array{Int64,1})

	if dim==1
		
		board[index,:]=line

	elseif dim==2

		board[:,index]=line
	end

	nothing

end

function printBoard(board)

	boardStr=""
	for rowIdx=1:size(board,1)
		for colIdx=1:size(board,2)
			tmpStr=@sprintf("%6d",board[rowIdx,colIdx])
			boardStr=string(boardStr,tmpStr)
		end
		boardStr=string(boardStr,"\n")
	end
	return boardStr
end


function initBoard(boardSize=4)
	
	# Initialize a board

	board=zeros(Int64,boardSize,boardSize)	

	for i=1:2
		board=addTile(board)
	end

	return board

end


function addTile(board)
	
	newTile(x)= (x>0.9) ? 4: 2

	newboard=copy(board)

	# get index = zero
	i,j,v=findnz(newboard.==0)

	#randomly choose a index
	newTileIndex=rand(1:length(i))

	#put tile on the board

	assert(newboard[i[newTileIndex],j[newTileIndex]]==0)
	newboard[i[newTileIndex],j[newTileIndex]]=newTile(rand())

	#return the new board
	return newboard
end


end