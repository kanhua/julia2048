import core2048X
import core2048


function testAddTiles(addTileFunc::Function)
	
	testTimes=100000
	testBoard=core2048.initBoard()

	for i=1:testTimes
		addTileFunc(testBoard)
	end
end


function testBoardMove(boardMoveFunc::Function)
	testTimes=100000
	testBoard=core2048.initBoard()


	for i=1:testTimes
		boardMoveFunc(testBoard,1)
	end
end

function testMoveMerge(moveMergeFunc::Function)

	testTimes=100000
	testLine=[0,0,0,0]


	for i=1:testTimes
		moveMergeFunc(testLine,1)
	end


end

timeVal=@time(testAddTiles(core2048.addTile))

println(timeVal)

timeVal=@time(testAddTiles(core2048X.addTile))

println(timeVal)


timeVal=@time(testMoveMerge(core2048.moveMerge))
println(timeVal)

timeVal=@time(testMoveMerge(core2048X.moveMerge))
println(timeVal)


timeVal=@time(testBoardMove(core2048.boardMove))

println(timeVal)

timeVal=@time(testBoardMove(core2048X.boardMove))

println(timeVal)

