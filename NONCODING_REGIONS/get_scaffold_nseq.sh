#!/bin/bash
ls noncoding-region-alignment/chrScaffold/ | while read file; do 
	nseq=$(grep -c ">" noncoding-region-alignment/chrScaffold/${file})
	if [ ${nseq} -lt 241 ]; then
		echo "${file} ${nseq}" >> scaffold_nseq.txt
	fi
done

