$ ->

	user_id=1

	class Player extends Backbone.Model
		defaults: ->
			rank: 0
			score: 5000
		
		validate: (attrs) ->
			"need your name" if attrs['name'] == ''
			
	class Players extends Backbone.Collection
		model: Player
		url: "/api/gameusers"

		findSelf: ->
			curusers= @.models.filter( (c) ->
				c.get('curuser')
			)
			if curusers != undefined && curusers.length == 1
				return curusers[0]
			else
				log("not log in")
				null
	
	class AppView extends Backbone.View
		el: $("#app")  
	
		events:
			"click #btn-start": "start"
	
		initialize: ->
			log("AppView initialize")
			this.$tbody=$(".rank-table tbody")
			players.on({'add':this.addOne,'reset':this.addAll})
			players.fetch()

			setInterval( () ->
  				players.fetch()
				, 10000)

		showResult: (bjs)->
			if bjs != null
				if bjs.get("winner") == players.findSelf()
					message("You win last game. Attender (" + bjs.get("attender").name + ") draw point "+ bjs.get("attenderscore"))
				else if bjs.get("winner") == null
					message("You draw last game with attender (" + bjs.get("attender").name + ")")
				else
					message("You lost last game. Attender (" + bjs.get("attender").name + ") draw point "+ bjs.get("attenderscore"))
				bjs.set("unread",false)
				bjs.save()
		
		initUser: ->
			log("init user")
			users=new Users()
			users.on("add",(user) ->
				log("Current user: "+user.get('name'))
				current_user=user)
			users.fetch({data: $.param({id: 1})})

		start: (e) =>
			log("AppView start")
			if players.findSelf() == null
				message("Please sign in")
				return
			$("#welcome").hide()
			$("#desk").show()
			game.reset()
			game.initGame()
			gameView.resetView()
		
		addOne: (player) ->
			player.set("rank",$(".rank-table tbody").children("tr").length+1)
			if player.get('rank') < 11
				rankView = new RankView({model: player})
				$(".rank-table tbody").append(rankView.render().el)
	
		addAll: ->
			log("AppView addAll")
			for idx in [1..players.length]
				alertplayers[idx].name
			players.each(this.addOne,this)
	
	class RankView extends Backbone.View
		tagName: "tr"
	
		template: JST['blackjacks/rank']
	
		initialize: ->
			@listenTo(@model,'change',@render)
			@model.view = this
	
		render: ->
			$(@el).html(@template(player: @model))
			return this
	
	class Card extends Backbone.Model
		getValue: ->
			pv=parseInt(@get('face'),10)
			log("pv="+pv)
			return 1 if isNaN(pv)
			pv

	class Blackjack extends Backbone.Model
	    	model: ->
     			holder: User

	class User extends Backbone.Model
		urlRoot: "/api/gameusers"

	class Users extends Backbone.Collection
		model: User
		url: "/api/gameusers"

	class Blackjacks extends Backbone.Collection
		model: Blackjack
		url: "/api/blackjacks"
	
	class Game extends Backbone.Collection
		model: Card
		url: "game"
		pile: []
		idx:0
		total:0
	
		initialize: ->
			log("Game initialize")
			@newPile()


		initGame: ->
			log("Game new game")
			@total=0
			@drawCard()
			@drawCard()
	
		newPile: ->
			card=["2","3","4","5","6","7","8","9","10","v","d","k","t"]
			face=["b","p","k","c"]
	
			@pile=[]
	
			for i in [0..face.length-1]
				for j in [0..card.length-1]
					@pile.push(card[j]+face[i])
	
			for i in [@pile.length-1..1]
				j = Math.floor Math.random() * (i + 1)
				[@pile[i], @pile[j]] = [@pile[j], @pile[i]]
	
		drawCard: ->
			log("Game draw card: "+@pile[@idx])
			newCard=new Card({face:@pile[@idx]})
			@add(newCard)
			@total+=newCard.getValue()
			gameView.checkTotal()
			@pile[@idx++]

		submit: ->
			log("Game submit")
			bjs=new Blackjacks()
			bjv=new BlackjackView()
			bjv.listenTo(bjs,'add',bjv.processBJinstance)
			bjs.fetch({data: $.param({opengame: true})})
			log("fetch done")

		old: ->
			carray=[]
			@.each (m) -> 
				carray.push(m.get("face"))
			log("cardStr: "+carray)
			bjModel=new Blackjack()
			bjModel.set("pile",carray.toString())
			log("bjstr:"+bjModel.get("pile"))
			bjModel.set("point",@total)
			bjModel.save()
			log("bj save finish")
			log("bj winner="+bjModel.get("winner"))

		getPile: ->
			carray=[]
			@.each (m) -> 
				carray.push(m.get("face"))
			carray

		getTotal: ->
			@total

	class BlackjackView extends Backbone.View
		
		processBJinstance: (bjs)->
			log("bjv P")
			current_user=players.findSelf()
			log("current_user :"+current_user.length)
			log("current_user :"+current_user.get("name"))
			holderscore=bjs.get('holderscore')
			winner=null

			if holderscore == null
				log("You are holder")
				bjs.set("holderscore",game.getTotal())
				bjs.set("holderpile",game.getPile().toString())
				bjs.set("holder", current_user)
				message("Please wait other user play with you") 
			else
				holder=players.get(bjs.get("holder").id)
				log("Join game holder: "+ holder.get("name"))
				log("holderscore:"+holderscore)
				bjs.set("attenderscore",game.getTotal())
				log("getPile: "+game.getPile().toString())
				bjs.set("attenderpile",game.getPile().toString())
				bjs.set("attender", current_user)
				if holderscore>21
					if bjs.get("attenderscore") < 22
						winner=current_user
				else if bjs.get("attenderscore") > 21
					if holderscore < 22
						winner=holder
				else if holderscore > bjs.get("attenderscore")
					winner=holder
				else if holderscore < bjs.get("attenderscore")
					winner=current_user
				bjs.set("winner",winner)

				if winner==current_user
					message("You win the game. Holder (" + holder.get("name") + ") draw point:" + bjs.get("holderscore")) 
					log(current_user.get("name"))
					current_user.set("credit",current_user.get("credit")+200)
					current_user.set("score",current_user.get("score")+200)
					current_user.save()
				else if winner==holder
					message("You lose the game. Holder (" + holder.get("name") + ") draw point:" + bjs.get("holderscore")) 
					holder.set("credit",holder.get("credit")+200)
					holder.set("credit",holder.get("credit")+200)
					holder.save()
				else
					message("Draw game with Holder (" + holder.get("name") + ")")
			bjs.save()
			log("bjs saved")
	
	class GameView extends Backbone.View
		el: $("#app")

		events:
			"click #btn-draw": "drawCard"
			"click #btn-finish": "finish"

		initialize: ->
			log("GameView initialize")
			$("#mydesk").html('')
			@listenTo(game,'add',@addOne,this)
			@listenTo(game,'reset',@addAll,this)
			@checkTotal()

		resetView: ->
			log("GameView resetView")
			$("#btn-start").hide()
			$("#btn-draw").show()
			$("#btn-finish").show()
			$("#message").text("")

		checkTotal: ->
			total=game.getTotal()
			$("#totalPoint").text(total)
			if(total>21)
				$("#message").text("You done")
				@finish()
			else if(total==21)
				$("#message").text("you rock")
				@finish()

		finish: ->
			log("GameView finish")
			game.submit()
			$("#btn-start").show()
			$("#btn-draw").hide()
			$("#btn-finish").hide()

		drawCard: ->
			log("GameView drawCard")
			game.drawCard()
			@checkTotal()
	
		addOne: (card) ->
			log("GameView addOne")
			cardView = new CardView({model: card})
			$("#mydesk").append(cardView.render().el)

		addAll: (cards) ->
			log("GameView addOne")
			$("#mydesk").html('')
			cards.each(this.addOne,this)

	class CardView extends Backbone.View
		tagName: "td"
		template: JST['blackjacks/game']
		initialize: ->
			log("CardView initialize")
			@listenTo(@model,'change',@render)
			@model.view = this
	
		addOne: ->
			log("GameView addOne")

		render: ->
			log("GameView render")
			log(@model.get("face"))
			$(@el).html(@template(card: @model))
			return this

	log = (msg) ->
		$("#log").html(msg+"<br/>"+$("#log").html())

	message = (msg) ->
		$("#message").text(msg)
	
	players=new Players()
	appView=new AppView()
	game=new Game()
	gameView=new GameView()
