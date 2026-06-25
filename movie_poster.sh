#!/bin/bash
export API_KEY=""
#echo "API_KEY: ${API_KEY}"

if [[ ${API_KEY} = "" ]]; then
	echo "register at themoviedb.org as developer to get your API_KEY"
else
	query=$(echo "'$@'")
	#echo "query: ${query}"
	response=$(curl -s -G -H "Authorization: Bearer ${API_KEY}" -H "accept: application/json" --data-urlencode "query=${query}" https://api.themoviedb.org/3/search/movie)
	#echo ${response} | jq -r '.results[0]'
	
	poster_path=$(echo ${response} |  jq -r '.results[0].poster_path'); 
	title=$(echo ${response} | jq -r '.results[0].title' | sed "s/ /./g"); 
	file=${title}.jpg
	
	url="http://image.tmdb.org/t/p/w500${poster_path}" 
	#echo "url: ${url}"

	curl -s "${url}" -o ${title}.jpg

	if [[ $? -eq 0 ]]; then
		echo "'${file}' saved for query ${query}"
	fi
fi
