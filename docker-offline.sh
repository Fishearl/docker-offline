#/bin/bash
IMAGEDIR="offline-images"
case $1 in 
	"save")
		mapfile -t images < <(cat docker-compose.yml | grep image | cut  -d ':' -f2,3 | cut -c2-)
		
		if [ ${#images[@]} -eq 0 ]; then
			exit 1
		fi
		
		if [ ! -d "$IMAGEDIR" ]; then
			echo "Creating $IMAGEDIR"	
			mkdir $IMAGEDIR
		fi

		for image in "${images[@]}"
		do
			echo $image
			docker save $image > $IMAGEDIR/$image.tar
		done
		;;

	"load")
		mapfile -t images < <(ls $IMAGEDIR | grep .tar)
		
		if [ ! -d "$IMAGEDIR" ]; then
			echo "Creating $IMAGEDIR"	
			mkdir $IMAGEDIR
		fi
		
		for image in "${images[@]}"
		do
			echo $image
			docker load < $IMAGEDIR/$image
		done
		;;
	*)
		echo $0 "[ load | save ]"
		;;
esac

