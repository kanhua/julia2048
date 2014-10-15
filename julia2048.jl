module julia2048

export move, merge, moveMerge, boardMove, getLine, setLine, printBoard, initBoard, addTile

const ContinueGame=999
const WinGame=777
const LoseGame=444
const QuitGame=-99



function move(line::Array{Int64,1},direction::Int64)
	lineLen=length(line)

	nonZeroLine=line[line.>0]

	if length(nonZeroLine)<lineLen
		if direction >0
			newLine=[nonZeroLine,zeros(Int64,lineLen-length(nonZeroLine))]
		elseif direction < 0
			newLine=[zeros(Int64,lineLen-length(nonZeroLine)),nonZeroLine]
		end
		return newLine
	
	elseif length(nonZeroLine)==lineLen

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
	end

	return moveDir

end


function randomAgenit(board)

	legalMoves=getLegalMoves(board)

	lmIndex=rand(1:length(legalMoves))

	return legalMoves[lmIndex]

end



function greedyAgent(board)

	legalMoves,score=getLegalMoves_score(board)
	assert(length(legalMoves)>0)

	if length(score)>1
		maxIndex=findfirst(score.==max(score...))
	else
		maxIndex=1
	end

	return legalMoves[maxIndex]

end


function iterativeRandomAgent(board)

	legalMoves,score=getLegalMoves_eval(board,iterativeRandom)

	println(score)
	assert(length(legalMoves)>0)

	if length(score)>1
		maxIndex=findfirst(score.==max(score...))
	else
		maxIndex=1
	end


	return legalMoves[maxIndex]
end

function randomGen(N)	
	shift=2
	n=rand(1:(N+shift+1))
	while n<=shift || n==(N+shift+1)
		n=rand(1:(N+shift))
	end
	return n-shift
end



function iterativeRandomAgent2(board)


	startLegalMoves=getLegalMoves(board)

	@assert(length(startLegalMoves)>0)
	evalScores=zeros(length(startLegalMoves))
	evalSteps=zeros(length(startLegalMoves))
	forwardRuns=50

	for legalMoveIdx=1:length(startLegalMoves)

		predictExtraScores=zeros(forwardRuns)
		predictExtraSteps=zeros(forwardRuns)


		for i=1:forwardRuns
			extraGameScore=0
			totalSteps=1

			nextBoard,scorediff=boardMove(board,startLegalMoves[legalMoveIdx])

			extraGameScore=extraGameScore+scorediff
		
			nextBoard=addTile(nextBoard)
			
			legalMoves=getLegalMoves(nextBoard)


			while length(legalMoves) > 0

				input=legalMoves[rand(1:length(legalMoves))]

				nnextBoard,scorediff=boardMove(nextBoard,input)
	
				extraGameScore=extraGameScore+scorediff
		
				# Literally, we should put
				# "if isMoved(board,nnextBoard)>0" here,
				# but since we limit the possible moves to legalMoves, 
				# so we don't need it
				nnextBoard=addTile(nnextBoard)
				

				totalSteps=totalSteps+1


				legalMoves=getLegalMoves(nnextBoard)
				nextBoard=copy(nnextBoard)
			end

			#@printf("extra score %d of the first run %d\n",extraGameScore,i)
			predictExtraScores[i]=extraGameScore
			predictExtraSteps[i]=totalSteps
		end

		
		evalScores[legalMoveIdx]=mean(predictExtraScores)
		evalSteps[legalMoveIdx]=mean(predictExtraSteps)

	end


	println(evalScores)
	println(evalSteps)
	if length(evalScores)>1
		maxIndex=findfirst(evalScores.==max(evalScores...))
	else
		maxIndex=1
	end


	return startLegalMoves[maxIndex]

end




function getFreeTiles(board)

	i,j,v=findnz(board.==0)

	return length(i)

end


function isMoved(board::Array{Int64,2},nextBoard::Array{Int64,2})
	
	# Check whether the board is moved

	return !(board==nextBoard)
end


function getLegalMoves(board::Array{Int64,2})

	possibleMoves=[1,-1,2,-2]
	
	# Construct an array for legal moves
	legalMoves=[]

	for i=1:length(possibleMoves)
		newBoard,score=boardMove(board,possibleMoves[i])
		if isMoved(board,newBoard)

			legalMoves=[legalMoves,possibleMoves[i]]
			
		end
	end


	return legalMoves

end


function getLegalMoves_score(board)
	
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


function getLegalMoves_eval(board::Array{Int64,2}, eval::Function)


	possibleMoves=[1,-1,2,-2]
	
	# Construct an array for legal moves
	legalMoves=[]
	nextScores=[]

	for i=1:length(possibleMoves)
		newBoard,score=boardMove(board,possibleMoves[i])
		if isMoved(board,newBoard)

			legalMoves=[legalMoves,possibleMoves[i]]
			nextScores=[nextScores,eval(newBoard)]
		end
	end


	return legalMoves,nextScores
end


function getGameScore(board)

    tmp=0

    for col=1:size(board,2), row=1:size(board,1)
    	tmp=tmp+ssum(board[row,col])
    end
    return tmp
end

function ssum(N::Int64)

	tmp=0
	if N>2
		tmp=N+2*ssum(convert(Int64,N/2))
	end
	return tmp
end

function iterativeRandom(board::Array{Int64,2})


	moves=10

	scores=zeros(moves)

	for i=1:length(scores)

		nextBoard=copy(board)

		totalSteps=0

		legalMoves=getLegalMoves(nextBoard)

		gameScore=0

		while length(legalMoves) > 0

			input=legalMoves[rand(1:length(legalMoves))]

			nnextBoard,scorediff=boardMove(nextBoard,input)

			gameScore=gameScore+scorediff
			
			# Literally, we should put
			# "if isMoved(board,nnextBoard)>0" here,
			# but since we limit the possible moves to legalMoves, 
			# so we don't need it
			nnextBoard=addTile(nnextBoard)
			

			totalSteps=totalSteps+1


			legalMoves=getLegalMoves(nnextBoard)
			nextBoard=copy(nnextBoard)
		end

		#scores[i]=getGameScore(nextBoard)
		scores[i]=gameScore
	end
	
	return mean(scores)
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
	totalSteps=1
	gameScore=0

	while gameState(board)==ContinueGame

		printOut=true	

		if printOut==true
			println(printBoard(board))
			@printf("current score: %d\n", gameScore)
			@printf("accumulated steps: %d\n", totalSteps)
			@printf("heurisitic score: %d\n", getGameScore(board))
		end
		
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

	println("the last board:")
	println(board)
	@printf("total elapsed steps: %d\n",totalSteps)
	@printf("final gamescore: %d\n",gameScore)


	return gameScore
end

end




