using julia2048


function testAddTiles(addTileFunc::Function)
	
	testTimes=100000
	testBoard=initBoard()

	for i=1:testTimes
		addTileFunc(testBoard)
	end
end

timeVal=@time(testAddTiles(addTile))

println(timeVal)