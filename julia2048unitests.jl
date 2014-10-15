using julia2048

function testmove()

	println("testint move():")
	@assert(move([0,0,2,2],1)==[2,2,0,0])
	@assert(move([0,2,0,2],-1)==[0,0,2,2])
	println("test pass")

end

function testmerge()
	
	println("testing merge():")
	println(merge([0,2,2,0],1))
	@assert(merge([0,2,2,0],1)==([0,4,0,0],4))
	@assert(merge([0,2,0,2],1)==([0,2,0,2],0))
	@assert(merge([4,4,8,8],1)==([8,0,16,0],24))
	@assert(merge([2,2,2,0],-1)==([2,0,4,0],4))
	@assert(merge([2,2,2,0],1)==([4,0,2,0],4))
	println("test pass!")

end


function testmovemerge()
	println("testing moveMerge()")
	@assert(moveMerge([0,2,0,2],1)==([4,0,0,0],4))
	@assert(moveMerge([0,2,0,0],-1)==([0,0,0,2],0))
	@assert(moveMerge([8,8,8,2],-1)==([0,8,16,2],16))

	println("test pass")
end

function testboardMove()

	@assert(boardMove([0 0 0 0;0 0 0 0;0 0 0 0;0 0 0 0],1)==([0 0 0 0;0 0 0 0;0 0 0 0;0 0 0 0],0))
	@assert(boardMove([0 2 2 0;0 0 0 0;0 0 0 0;0 0 0 0],1)==([4 0 0 0;0 0 0 0;0 0 0 0;0 0 0 0],4))
	@assert(boardMove([0 2 2 0;0 0 0 0;0 0 0 0;0 0 0 0],-1)==([0 0 0 4;0 0 0 0;0 0 0 0;0 0 0 0],4))
	@assert(boardMove([0 2 2 0;0 0 0 0;0 0 0 0;0 0 0 0],-2)==([0 0 0 0;0 0 0 0;0 0 0 0;0 2 2 0],0))
	@assert(boardMove([0 2 0 0;0 2 0 0;0 0 0 0;0 0 0 0],-2)==([0 0 0 0;0 0 0 0;0 0 0 0;0 4 0 0],4))



	@assert(boardMove([0 0 0 0;0 0 0 0;2 8 2 0;4 2 4 2],-2)==([0 0 0 0;0 0 0 0;2 8 2 0;4 2 4 2],0))


end

function testprintBoard()

	println(printBoard([0 0 0 0;0 0 0 0;0 0 0 0;0 0 0 0]))

	println(printBoard([1024 0 0 0;0 1024 0 0;0 0 1024 0; 0 0 0 1024]))

	
	
end


function testaddTile()

	println(addTile([0 0 0 0;0 0 0 0;0 0 0 0;0 0 0 0]))

	println(addTile([1024 0 0 0;0 1024 0 0;0 0 1024 0; 0 0 0 1024]))
	
end


function testGetFreeTiles()

	@assert(getFreeTiles([0 0 0 0;0 0 0 0;0 1 0 0;0 0 0 0])==15)
end

function testGetLegalMoves()

	@assert(getLegalMoves([0 0 0 0;0 0 0 0;0 1 0 0;0 0 0 0])==[1,-1,2,-2])

end

function testGameState()

	@assert(gameState([0 0 0 0; 0 0 0 2048; 0 0 0 0; 0 0 0 0])==WinGame)
	@assert(gameState([2 4 2 4; 4 2 4 2; 2 4 2 4; 4 2 4 2])==LoseGame)

end



testmove()
testmerge()
testmovemerge()
testboardMove()
testprintBoard()

testaddTile()

testGetFreeTiles()
testGetLegalMoves()
testGameState()