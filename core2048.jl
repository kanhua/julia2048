module core2048

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

	return line,addScore
end



function moveMerge(line::Array{Int64,1},direction::Int64)

	addScore=0
	line=move(line,direction)
	
	line,addScore=merge(line,direction)
	if addScore >0
		line=move(line,direction)
	end

	return line,addScore
end


function boardMove(board,direction)

	newBoard=copy(board)
	addScore=0
	for rowIdx=1:size(newBoard,abs(direction))
		line=getLine(newBoard,abs(direction),rowIdx)
		newLine,score=moveMerge(line,direction)
		addScore=addScore+score
		newBoard=setLine(newBoard,abs(direction),rowIdx,newLine)
	end

	return newBoard,addScore
end


function getLine(board,dim,index)

	if dim==1
		
		return reshape(board[index,:],size(board,dim))

	elseif dim==2

		return reshape(board[:,index],size(board,dim))

	end

end


function setLine(board,dim,index,line)

	if dim==1
		
		board[index,:]=line

	elseif dim==2

		board[:,index]=reshape(line,1,size(board,dim))

	end

	return board

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
	
	newboard=copy(board)
	flatBoard=reshape(newboard,size(board,1)*size(board,2))

	# get index = zero
	freeTileIndex=find(flatBoard.==0)

	#randomly choose a index
	newTileIndex=rand(1:length(freeTileIndex))

	tileToChoose=[ones(Int64,9).*2,4]

	#chosse a tile
	newTile=rand(1:length(tileToChoose))

	#put tile on the board

	assert(flatBoard[freeTileIndex[newTileIndex]]==0)
	flatBoard[freeTileIndex[newTileIndex]]=tileToChoose[newTile]

	#return the new board
	return reshape(flatBoard,size(board,1),size(board,2))

end

end