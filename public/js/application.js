$(document).ready(function(){
	console.log('a')

	var question = function(f){
		f.preventDefault(); 
		console.log('hi');
		// debugger
		$.ajax({
			url: "/question",
			method: "POST",
			data: $(this).parent().serialize(),
			dataType: 'JSON',
			success: function(data){
				console.log(data)
				$('.card_blocks').append("<div class='card' style='width: 40rem;'>\
				  <div class='card-header'>\
				  	<h6 class='question_by'><a href='/user/"+ data.user +"'> "+ data.person +": </a></h6>\
				  	<div class='question_title'>\
				  		<h4 class='card-title'><a href='/one_question/"+ data.id +"'> "+ data.message +"</a></h4>\
				  			\
				  			<form action='/questionvote' method='post' class='up'>\
				  			 	<input type='hidden' name='vote' value=1>\
				  			 	<input type='hidden' name='question_id' value="+ data.id +">\
				  			 	<button type='submit' class='upvote'>Up</button>\
				  			</form>\
\
				  			<h8 id='number_of_votes_"+ data.id +"' class='voteshow'>\
				  			"+ data.vote_count +"</h8>\
\
				  			<form action='/questionvote' method='post' class='down'>\
				  				<input type='hidden' name='vote' value=0>\
				  				<input type='hidden' name='question_id' value="+ data.id +">\
				  				<button type='submit' class='downvote'>Down</button>\
				  			</form>\
				  			\
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
		// debugger
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
					<h8><a href='/user/"+ data.user +"'>\
	    			"+ data.person +"\
			    			: </a></h8>\
			    		</div>\
			    		<div class = 'given_answer'>\
			    			" + data.message +" \
    			    		<div class='space'>\
    					    </div>\
    					    \
			    			<form action='/answervote' method='post' class='ansup'>\
			    			 	<input type='hidden' name='vote' value=1>\
			    			 	<input type='hidden' name='question_id' value="+ data.user +">\
			    			 	<input type='hidden' name='answer_id' value="+ data.answer_id +">\
			    			 	<button type='submit' class='ansupvote'>Up</button>\
			    			</form>\
		\
			    			<h10 id='ans_number_of_votes_"+ data.answer_id +"' class='ansvoteshow'>\
							"+ data.vote_count +"</h10>\
		\
			    			<form action='/answervote' method='post' class='ansdown'>\
			    				<input type='hidden' name='vote' value=0>\
			    				<input type='hidden' name='question_id' value="+ data.user +">\
			    				<input type='hidden' name='answer_id' value="+ data.answer_id +">\
			    				<button type='submit' class='ansdownvote'>Down</button>\
			    			</form>\
			    		</div>")
			}
		});
	};

	var upvote = function(f){
		f.preventDefault();
		// var id =$(this).parent().siblings()[2].id;
		// debugger
		$.ajax({
			url: "/questionvote",
			method: "POST",
			data: $(this).siblings().serialize(),
			success: function(data){
				data = JSON.parse(data)
				// debugger
				console.log(data)
				$('#number_of_votes_'+data.vote.question_id).html(data.count)
			}

		});
		
	};

	var ansupvote = function(f){
		f.preventDefault();
		// var id =$(this).parent().siblings()[2].id;
		// debugger
		$.ajax({
			url: "/answervote",
			method: "POST",
			data: $(this).siblings().serialize(),
			success: function(data){
				data = JSON.parse(data)
				// debugger
				console.log(data)
				$('#ans_number_of_votes_'+data.vote.answer_id).html(data.count)
			}

		});
		
	};

	$('.print').each(function(event){ /* select all divs with the item class */
		
			var max_length = 50; /* set the max content length before a read more link will be added */
			
			if($(this).html().length > max_length){ /* check for content length */
				
				var short_content 	= $(this).html().substr(0,max_length); /* split the content in two parts */
				var long_content	= $(this).html().substr(max_length, $(this).html().length);
				// debugger 
			$(this).html(short_content+
									 '<a href="#" class="read_more"><br/>Read More</a>'+
									 '<span class="more_text" style="display:none;">'+long_content+'</span>'); /* Alter the html to allow the read more functionality */
							 
				$(this).find('a.read_more').click(function(event){ /* find the a.read_more element within the new html and bind the following code to it */
	 
					event.preventDefault(); /* prevent the a from changing the url */
					$(this).hide(); /* hide the read more button */
					$(this).parents('.print').find('.more_text').show(); /* show the .more_text span */
			 
				});
				
			}
		});

	$('.card-title').each(function(event){ /* select all divs with the item class */
		
			var max_length = 80; /* set the max content length before a read more link will be added */
			
			if($(this).html().length > max_length){ /* check for content length */
				
				var short_content 	= $(this).html().substr(0,max_length); /* split the content in two parts */
				var long_content	= $(this).html().substr(max_length, $(this).html().length);
				// debugger 
			$(this).html(short_content+
									 '<a href="#" class="read_more"><br/>Read More</a>'); /* Alter the html to allow the read more functionality */
							 

				$(this).find('a.read_more').click(function(event){ /* find the a.read_more element within the new html and bind the following code to it */
	 				// debugger 
					event.preventDefault(); /* prevent the a from changing the url */
					$(this).hide(); /* hide the read more button */
					$(this).siblings().html(short_content + long_content); /* show the .more_text span */
			 
				});
				
			}
		});




	$('body').on('click', '.upvote', upvote);
	$('body').on('click', '.downvote', upvote);
	$(document).on('click', '.answer' ,answer);
	$('#ask_button').on('click',question);
	$('body').on('click', '.ansupvote', ansupvote);
	$('body').on('click','.ansdownvote' ,ansupvote);

});