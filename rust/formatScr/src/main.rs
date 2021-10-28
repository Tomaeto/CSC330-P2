use std::fs;
use std::io;

//Program for printing formatted lines from input text file
//Removes numbers and extra spaces, prints lines w/ right-justified
//	line number and max line length of 60 w/ words not cut across lines
//Also prints lines w/ most and least words w/ left-justified line numbers
//By Adrian Faircloth
//10-28-21

fn main() {
	//Getting user input for file path
	let mut filename = String::new();
	println!("Enter input file path:");
	io::stdin().read_line(&mut filename)
	    .expect("Something went wrong reading line");
	//Removing newline char from end of filename
	filename = filename.trim_end().to_string();

	//Reading file to string contents
	let mut contents = fs::read_to_string(filename).expect("Error reading file");
		  
	//Removing any extra spaces from contents, replaces newline characters w/ spaces
	while contents.find("  ") != None
	{
	contents = contents.replace("  ", " ");
	}
	contents = contents.replace("\n", " ");
	//Removing numbers from contents
	contents = contents.replace(&['0','1','2','3','4','5','6','7','8','9'][..], "");
	
	//Getting all words from contents and storing them in vector words
	//As words are found, they are removed from contents until string is empty
	let mut words: Vec<String> = Vec::new();
	let mut word = String::new();
	let mut space_index = contents.find(' ').unwrap_or(contents.len());
	//While there are spaces in contents, get front word, add word to
	//	vector, remove word and leading space from contents, and find next space
	while contents.find(' ') != None
	{
		word = (&contents[0..space_index]).to_string();
		word.push(' ');
		contents = contents.replacen(&word, "", 1);
		word = word.trim_end().to_string();
		words.push(word);	
		space_index = contents.find(' ').unwrap_or(contents.len());
	}
	//Adding final word in contents to words w/ nextline char trimmed from end of word
	//Reversing words so the words can be popped in order
	word = (&contents[..]).to_string();
	word = word.trim_end().to_string();
	words.push(word);
	words.reverse();

	//Building formatted lines w/ max of 60 chars from vector of words
	//Lines cannot have words cut across lines
	//Also finds and stores lines w/ most and least words
	let mut lines: Vec<String> = Vec::new();
	let mut line = String::new();
	let mut num_words = 0;
	let mut most_words = 0;
	let mut least_words = 0;
	let mut most_line = String::new();
	let mut least_line = String::new();
	
	//While there are words in vector, pop word and build lines
	word = words.pop().unwrap().to_string();
	while words.is_empty() != true
	{
		//If current word fits in line, add it to line
		if line.chars().count() + word.chars().count() <= 60
		{
			num_words = num_words + 1;
			line.push_str(&word);
			//If line can possibly hold another word, add space to line
			if line.chars().count() < 60
			{
				line.push(' ');
			}
			word = words.pop().unwrap().to_string();
		} 
		else
		{
			//If word cannot fit in line, add line to vector lines
			//	and check if line is either longest or shortest
			//After, reset line and word counter
			lines.push(line.clone());
			if num_words > most_words
			{
				most_line = line.clone();
				most_words = num_words;
			}
			else if num_words < least_words || least_words == 0
			{
				least_line = line.clone();
				least_words = num_words;
			}
			line = String::new();	
			num_words = 0;
		}
	}
	//Adding final line to vector lines and checking if line is
	//	either longest or shortest
	lines.push(line.clone());
	if num_words > most_words
	{
		most_line = line.clone();
		most_words = num_words;
	}
	else if num_words < least_words || least_words == 0
	{
		least_line = line.clone();
		least_words = num_words;
	}
	
	//Printing formatted lines w/ line number right-justified
	//	to col 8 and output starting on col 11
	let mut most_linenum = 0;
	let mut least_linenum = 0;
	let mut line_str = String::new();

	for i in 0..lines.len()
	{
		let j = i + 1;
		if most_line == lines[i]
		{
			most_linenum = j;
		}
		else if least_line == lines[i]
		{
			least_linenum = j;
		}
		line_str = j.to_string();
		while line_str.chars().count() < 8
		{
			line_str.insert(0, ' ');
		}
		line_str.push_str("  ");
		println!("{}{}", line_str, lines[i]);
	}
	
	println!(" ");

	//Printing lines w/ most and least words w/ line number
	//	left-justified to col 8 and output starting
	//	on col 21
	line_str = String::from("LONG   ");
	line_str.push_str(&most_linenum.to_string());
	while line_str.chars().count() < 20
	{
		line_str.push(' ');
	}
	println!("{}{}", line_str, most_line);
	
	line_str = String::from("SHORT  ");
	line_str.push_str(&least_linenum.to_string());
	while line_str.chars().count() < 20
	{
		line_str.push(' ');
	}
	println!("{}{}", line_str, least_line);
	
}
