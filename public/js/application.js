$(document).ready(function(){
	console.log('a')

	var question = function(f){
		f.preventDefault(); 
		console.log('hi');
		debugger
		$.ajax({
			url: "/question",
			method: "POST",
			data: $(this).parent().serialize(),
			dataType: 'JSON',
			success: function(data){
				console.log(data)
				$('.card_blocks').append("<div class='card' style='width: 40rem;'>\
				  <div class='card-header'>\
				  	<h6 class='question_by'><a href='/user/"+ data.id +"'> "+ data.person +": </a></h6>\
				  	<div class='question_title'>\
				  		<h4 class='card-title'><a href='/one_question/"+ data.id +"'> "+ data.message +"</a></h4>\
				  	</div>\
				  </div>\
				  <div class='card-block'>\
				    <div class='card-text'>\
				    	<div class ='list'>\
					    	<h6 class='card-subtitle mb-2 text-muted' id="+ data.id +"><br></h6>\
				    	</div>\
				    </div>\
				        <form action='/answer' method='post' class ='cards'>\
				    	    <div class='answers'>\
				    	    	<input type='text' name='answer' id ="+ data.id +" \
				    	    	placeholder = 'answer' style='width: 30rem;'>\
				    	    </div>\
				    	    <input type='hidden' name='question_id' value="+ data.id +">\
				    	    <button class='answer' type='submit' id ="+ data.id +">Answer</button>\
				        </form>\
				  </div>\
				</div>")
			}
		});

	};

	var answer = function(f){
		f.preventDefault(); 
		debugger
		var question_id = this.id ; 
		// debugger
		$.ajax({
			url: "/answer",
			method: "POST",
			data: $(this).parent().serialize(),
			dataType: 'JSON',
			success: function(data){
				console.log(data)
				// debugger 
				$('.list').children('#'+question_id).append("<div class = 'answer_by'>\
					<h8><a href='/user'>\
	    			"+ data.person +"\
	    			: </h8>\
	    		</div>\
	    		<div class = 'given_answer'>\
	    			" + data.message +" \
	    		</div>")
			}
		});
	};


	$(document).on('click', '.answer' ,answer);
	$('#ask_button').on('click',question);
});