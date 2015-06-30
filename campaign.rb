#campaign.rb

system "clear"


module Prompt
	
	#method to ask a question and get a response from the keyboard. Answer options may or may not be included.
	def ask_for_options(question, options = [])
		if options.length > 0
			begin
			puts question
			answer = gets.chomp.downcase
			end until options.include? answer
		else
			puts question
			answer = gets.chomp.downcase
		end
		answer
	end

	#puts a line of 100 asterisks.
	def separator
		puts "*"*100
	end

end



#definition of person class.
class Person

	attr_accessor :name, :party, :politician, :politics

	def initialize(name, politics)
		@name = name
		@party = "N/A"
		@politics = politics
		@politician = "no"
	end

	def inspect
		@name
	end

	def to_s
		@name
	end

end



#definition of politician class.
class Politician < Person
	
	attr_accessor :name, :party, :politician, :politics, :votes

	def initialize(name, party)
		@name = name
		@party = party
		@politics = "N/A"
		@politician = "yes"
		@votes = 1
	end

end


#definition of class campaign and its methods
class Campaign
	
	include Prompt 

	def initialize
		@characters = []
	end

	#method to display and "navigate" the main menu.
	def display_main_menu

	quit = "no"

		while quit == "no" do

			begin
	
			main_options = ["create", "list", "update", "vote", "leave"]
			main_option = ask_for_options("What would you like to do? -- Create, List, Update, Vote or Leave --", main_options)

				case main_option
					when "create"
						create
		 			when "list"
		 				list_characters
		 			when "update"
		 				update
		 			when "vote"
		 				vote
		 			when "leave"
		 				quit = ask_for_options("Are you sure you want to leave? -- yes or no --", ["yes", "no"])
		 			else
		 				puts "Please type in one of the options prompted."
				end

			end until main_options.include? main_option
		end
	end

	#method to create characters for this campaign with the role of politician or person(voter)
	def create
		
	system "clear"

		begin

		@human_options = ["politician", "person"]
		@party_options = ["republican", "democrat"]
		@politics_options = ["liberal", "conservative", "tea party", "socialist", "neutral"]
		
		human = ask_for_options("What would you like to create? -- Politician or Person --", @human_options)

			if human == "politician"
		  	
		  		pol_name = ask_for_options("Please enter the name of the politician.")
		  		party = ask_for_options("Please enter the party this new politician represents. -- Republican or Democrat --", @party_options)
		  		politician = Politician.new(pol_name, party)
		  		@characters << politician

			elsif human == "person"
		  		
		  		per_name = ask_for_options("Please enter the name of the person.")
		  		politics = ask_for_options("Please enter the political affiliation of this person. -- Liberal, Conservative, Tea Party, Socialist, or Neutral --", @politics_options)
		  		person = Person.new(per_name, politics)
		  		@characters << person
		  	
		  	else
		  		puts "Please type in one of the options prompted."
		 	end

		 	puts "A new character has been created with a role of #{human}."

		 end until @human_options.include? human
	end

	#method to list the characters created for this campaign.
	def list_characters
		
		system("clear")
		separator
		format = "%-25s %-25s %-25s %s"
		puts format % ["Role", "Name", "Party", "Politics"]
		
		@characters.each do |character|
  			
  			if character.politician == "yes"
  				puts format % ["Politician", character.name.capitalize, character.party.capitalize, character.politics.capitalize]
  			else
  				puts format % ["Voter", character.name.capitalize, character.party.capitalize, character.politics.capitalize]				
			end
		end
		separator
	end

	#method to update the characters on this campaign.
	def update
		
		old_name = ask_for_options("Please enter the name of the character you would like to update.")
		index_update = -1 #this index does not change its value unless a match for the name is found in the array of characters.

		@characters.each_with_index do |character, i|
  			if character.name == old_name
  				index_update = i #index_update is set to the index of the character matching the search.
  			end
  		end

  		if index_update >= 0 #if the index is >= 0 is because a match was found.
  			
  			new_name = ask_for_options("Please enter the new name for this character.")
  			@characters[index_update].name = new_name

  			if @characters[index_update].politician == "yes"
  				new_party = ask_for_options("Please enter the new party for this character. -- Republican or Democrat --", @party_options)
  				@characters[index_update].party = new_party
  			else
  				new_politics = ask_for_options("Please enter the new politics of this character. -- Liberal, Conservative, Tea Party, Socialist, or Neutral --", @politics_options)
  				@characters[index_update].politics = new_politics
  			end
  		
  		else

			puts "That character is not part of the current campaign."
  		
  		end
	end 



	def vote

	system "clear"

		politicians = []
		persons = []

		@characters.each do |character| 
			if character.politician == "yes" 
				politicians << character
			else
				persons << character
			end
		end

		#The code below assigns new votes randomly to candidates depending on the politics of the voter
		#and the party of the candidate. According to that relationship there are different weights 
		#each vote has. It does not work as a regular voting system as every voter could vote several times
		#and some times less votes than the total of voters could result, but the overall tendency does 
		#reflect the weight system and relationship between politics and parties.
		politicians.each do |poli|
			if poli.party == "republican"
				persons.each do |pers|
					case pers.politics
						when "tea party"
							@prob = 0.9
						when "conservative"
							@prob = 0.75
						when "neutral"
							@prob = 0.5
						when "liberal"
							@prob = 0.25
						when "socialist"
							@prob = 0.1
					end
					vote = rand < @prob
					poli.votes += 1 if vote 
				end
			else
				persons.each do |pers|	
					case pers.politics
						when "tea party"
							@prob = 0.1
						when "conservative"
							@prob = 0.25
						when "neutral"
							@prob = 0.5
						when "liberal"
							@prob = 0.75
						when "socialist"
							@prob = 0.9
					end
					vote = rand < @prob
					poli.votes += 1 if vote 
				end
			end
		end

		winner = ""
		constituence = 0
		politicians.each do |poli|  
			if poli.votes > constituence
				constituence = poli.votes
				winner = poli.name
			end
		end

		separator
		puts "The winner of this campaign is #{winner.capitalize}. Better times are ahead of us under our new leader!"
		separator

		politicians.map { |poli| poli.votes = 1 }

	end


end

#starting point of the simulation program.
puts("\n\n\n" + "*"*20 + " Welcome to a new campaign! " + "*"*20 + "\n\n\n")
campaign2015 = Campaign.new
campaign2015.display_main_menu




