const ContinueGame=999
const WinGame=777
const LoseGame=444
const QuitGame=-99



function move(line,direction)
	lineLen=length(line)

	nonZeroLine=line[line.>0]

	if direction >0
		newLine=[nonZeroLine,zeros(Int64,lineLen-length(nonZeroLine))]
	elseif direction < 0
		newLine=[zeros(Int64,lineLen-length(nonZeroLine)),nonZeroLine]
	end
	return newLine
end


function merge(line)

	addScore=0
	lineLen=length(line)
	for idx=1:lineLen
		nextidx=idx+1;
		if nextidx<=lineLen
			if line[idx]==line[nextidx]

				addScore=addScore+line[idx]
				line[idx]=line[idx]*2
				line[nextidx]=0
			end

		end
	end

	return line,addScore
end



function moveMerge(line,direction)

	line=move(line,direction)
	line,addScore=merge(line)
	line=move(line,direction)

	return line,addScore
end


function boardMove(board,direction)

	if direction==0
		return board, 0
	end


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
		
		return board[index,:]

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

	for i=1:3
		board=addTile(board)
	end

	return board

end




function addTile(board)

	flatBoard=reshape(board,size(board,1)*size(board,2))

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


function humanPlayer(board)

	promptStr="Enter your next move:"

	promptStr="請輸入方向(上(K),下(J),左(H),右(L),離開(Q)):"

	print(promptStr)

	input=chomp(readline())

	if input=="H" || input=="h"
		moveDir=1
	elseif input=="L" || input=="l"
		moveDir=-1
	elseif input=="K" || input=="k"
		moveDir=2
	elseif input=="J" || input=="j"
		moveDir=-2	
	elseif input=="Q" || input=="q"
		moveDir=QuitGame
	else
		moveDir=0

	end

	return moveDir

end


function getFreeTiles(board)

	i,j,v=findnz(board.==0)

	return length(i)

end


function isMoved(board,nextBoard)
	
	# Check whether the board is moved

	return !(board==nextBoard)
end


function getLegalMoves(board)

	possibleMoves=[1,-1,2,-2]
	
	# Construct an array for legal moves
	legalMoves=[]
	nextScores=[]

	for i=1:length(possibleMoves)
		newBoard,score=boardMove(board,possibleMoves[i])
		if isMoved(board,newBoard)

			legalMoves=[legalMoves,possibleMoves[i]]
			nextScores=[nextScores,score]
		end
	end


	return legalMoves,nextScores

end





function gameState(board)

	if max(board...)==2048
		return WinGame
	end

	if length(getLegalMoves(board))>0
		return ContinueGame
	else
		return LoseGame
	end

end


function gameLoop(player::Function)

	board=initBoard()
	totalSteps=0
	gameScore=0

	while gameState(board)==ContinueGame


		println(printBoard(board))
		@printf("current score: %d\n", gameScore)
		
		moveDir=player(board)
		
		if moveDir==QuitGame
			break
		end


		nextBoard,addScore=boardMove(board,moveDir)

		gameScore=gameScore+addScore

		if isMoved(board,nextBoard)>0
			nextBoard=addTile(nextBoard)
		end


		# Judge whether the game should continue

		if gameState(board)==WinGame
			println("Congrats! You Win!")
			break	
		elseif gameState(board)==LoseGame
			println("Good effort, but try again")
			break
		end


		board=nextBoard

		totalSteps=totalSteps+1
			

	end

	@printf("total elapsed steps: %d\n",totalSteps)
	@printf("final gamescore: %d\n",gameScore)
end




gameLoop(humanPlayer)


