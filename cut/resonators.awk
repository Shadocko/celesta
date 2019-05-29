BEGIN {
	# Plywood thickness (mm)
	thickness=5;
	# How much to offset outline out ot the shape to compensate for laser beam width (mm)
	offset=0.05;
	# Empty space between parts (mm)
	spacing=5;
	# Width of support bar (mm)
	support_w=27;
	# Swallowed depth of support bar (mm)
	support_d=27;
	# Distance of box bottom below this depth (mm)
	support_d2=15;
	# Maximum distance of notches to edge
	max_notch = 10;
	# Translate all groups along X this much
	glob_trans_x = 0;
	# Disable support hook if non-zero
	no_support = 1;
	# Do not include neck in model beyond first layer if non-zero (for e.g. 3D-printed neck)
	no_neck = 1;
	
	print "<svg"
	print "xmlns=\"http://www.w3.org/2000/svg\""
	print "width=\"210mm\""
	print "height=\"297mm\""
	print "viewBox=\"0 0 210 297\""
	print "version=\"1.1\">"
}

{
	# Note name
	note=$1
	# Radius of circular part of hole profile
	r=$4
	# Straight length of hole profile
	l=$5
	# Shallowness of hole
	ll=$6
	if( no_neck!=0 )
		ll = thickness;
	# Number of layers for hole part
	layers=ll/thickness
	# Resonator box inner width
	w=$12
	# Resonator box inner height
	h=$14
	# Resonator box inner height
	d=$13
	# Notch size in all directions
	notch_w = w/3.
	if( notch_w>max_notch )
		notch_w = max_notch
	notch_h = h/3.
	if( notch_h>max_notch )
		notch_h = max_notch
	notch_d = d/3.
	if( notch_d>max_notch )
		notch_d = max_notch
	# Position increment
	trans_x = 0;
	
	black_style = "style=\"fill:none;stroke:#000000;stroke-width:1pt;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1\""
	red_style = "style=\"fill:none;stroke:#FF0000;stroke-width:1pt;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;text-anchor:middle\""
	
	print "<g id=\"" note "\" transform=\"translate(" glob_trans_x ",0)\">"

	print "<g id=\"" note "_top\">"
	print "<text " red_style " transform=\"translate(0," (h/2) ") rotate(90)\">" note "</text>"
	print "<path " black_style " d=\""
	print "M" (-offset)","(-offset)
		print "L" (notch_w-offset)","(-offset)
		print "L" (notch_w-offset)","(-thickness-offset)
		print "L" (w-notch_w+offset)","(-thickness-offset)
		print "L" (w-notch_w+offset)","(-offset)
	print "L" (w+offset)","(-offset)
		print "L" (w+offset)","(notch_h-offset)
		print "L" (w+thickness+offset)","(notch_h-offset)
		print "L" (w+thickness+offset)","(h-notch_h+offset)
		print "L" (w+offset)","(h-notch_h+offset)
	print "L" (w+offset)","(h+offset)
		print "L" (w-notch_w+offset)","(h+offset)
		print "L" (w-notch_w+offset)","(h+thickness+offset)
		print "L" (notch_w-offset)","(h+thickness+offset)
		print "L" (notch_w-offset)","(h+offset)
	print "L" (-offset)","(h+offset)
		print "L" (-offset)","(h-notch_h+offset)
		print "L" (-thickness-offset)","(h-notch_h+offset)
		print "L" (-thickness-offset)","(notch_h-offset)
		print "L" (-offset)","(notch_h-offset)
	print "Z"
	print "\"/>"
	print "</g>"
	trans_x += w+2*thickness+spacing;
	
	for( i=0 ; i<layers ; ++i ) {
		print "<g id=\"" note "_bottom" i "\" transform=\"translate(" trans_x ",0)\">"
		print "<path " black_style " d=\""
		print "M" (-offset)","(-offset)
			print "L" (notch_w-offset)","(-offset)
			print "L" (notch_w-offset)","(-thickness-offset)
			print "L" (w-notch_w+offset)","(-thickness-offset)
			print "L" (w-notch_w+offset)","(-offset)
		print "L" (w+offset)","(-offset)
			print "L" (w+offset)","(notch_h-offset)
			print "L" (w+thickness+offset)","(notch_h-offset)
			print "L" (w+thickness+offset)","(h-notch_h+offset)
			print "L" (w+offset)","(h-notch_h+offset)
		print "L" (w+offset)","(h+offset)
			print "L" (w-notch_w+offset)","(h+offset)
			print "L" (w-notch_w+offset)","(h+thickness+offset)
			print "L" (notch_w-offset)","(h+thickness+offset)
			print "L" (notch_w-offset)","(h+offset)
		print "L" (-offset)","(h+offset)
			print "L" (-offset)","(h-notch_h+offset)
			print "L" (-thickness-offset)","(h-notch_h+offset)
			print "L" (-thickness-offset)","(notch_h-offset)
			print "L" (-offset)","(notch_h-offset)
		print "Z"
		print "\"/>"
		print "<path " black_style " d=\""
			print "M" (w/2+offset-r) "," (h/2 - l/2 + offset)
			print "a" (r-offset) "," (r-offset) " 0 1,1 " (2*(r-offset)) ",0"
			print "l0," l
			print "a" (r-offset) "," (r-offset) " 0 1,1 " (-2*(r-offset)) ",0"
			print "l0," (-l)
			print "Z"
		print "\"/>"
		print "</g>"
		trans_x += w+2*thickness+spacing;
	}
	
	for( i=0 ; i<2 ; ++i ) {
		print "<g id=\"" note "_side" i "\" transform=\"translate(" (trans_x-spacing) ",0)\">"
		if( no_support==0 && support_d+support_d2+20 > d+(1+layers)*thickness-notch_d ) {
			print "<rect x=\"" (layers*thickness+d+offset-notch_d) "\" y=\"" (offset-thickness) "\" width=\"" (notch_d+thickness-2*offset) "\" height=\"" (thickness-2*offset) "\" " black_style "/>"
			print "<rect x=\"" (layers*thickness+d+offset) "\" y=\"" (notch_h+offset) "\" width=\"" (thickness-2*offset) "\" height=\"" (h-2*notch_h-2*offset) "\" " black_style "/>"
		}
		print "<path " black_style " d=\""
		# Box top left
		print "M" (-offset) "," (-offset)
		print "l" (notch_d+layers*thickness) ",0"
		print "l0," (-thickness)
		if( no_support!=0 ) {
			print "l" (d-2*notch_d+2*offset) ",0"
			print "l0," thickness
			print "l" (notch_d+thickness) ",0"
			# Top right
			print "l0," (notch_h+2*offset)
			print "l" (-thickness) ",0"
			print "l0," (h-2*notch_h-2*offset)
			print "l" (thickness) ",0"
			print "l0," (notch_h+2*offset)
			# Bottom right
		}
		else {
			print "l" (support_d+support_d2-notch_d-layers*thickness) ",0"
			print "l0," (-support_w+2*offset)
			print "l" (-support_d) ",0"
			# Support top left
			print "l0,-10"
			print "l" (support_d+10+2*offset) ",0"
			if( support_d+support_d2+20 > d+(1+layers)*thickness-notch_d ) {
				outer_d = d+(1+layers)*thickness+10;
				if( support_d+support_d2+10 > outer_d )
					outer_d = support_d+support_d2+10;
				# Top right
				print "l" (outer_d-support_d-support_d2-10) "," (support_w)
				print "l0," (h+thickness+2*offset)
				print "l-10,10"
				# Bottom right
				print "l" (d+(1+layers)*thickness+10-outer_d) ",0"
			}
			else {
				print "l" (d+(layers+1)*thickness-support_d-support_d2-10) ","(support_w)
				print "l0," (10+2*offset)
				print "l" (-thickness-notch_d+2*offset) ",0"
				print "l0," (thickness-2*offset)
				# Top right
				print "l" (thickness+notch_d+2*offset) ",0"
				#print "l" (notch_d+thickness) ",0"
				print "l0," (notch_h+2*offset)
				print "l" (-thickness) ",0"
				print "l0," (h-2*notch_h-2*offset)
				print "l" (thickness) ",0"
				# Bottom right
				print "l0," (notch_h+2*offset)
			}
		}
		print "l" (-notch_d-thickness) ",0"
		print "l0," thickness
		print "l" (-d+2*notch_d-2*offset) ",0"
		print "l0," (-thickness)
		# Bottom left
		print "l" (-notch_d-layers*thickness) ",0"
		print "l0," (-notch_h-2*offset)
		print "l" (layers*thickness) ",0"
		print "l0,", (-h+2*notch_h+2*offset)
		print "l" (-layers*thickness) ",0"
		print "Z"
		print "\"/>"
		print "</g>"
		
		print "<g id=\"" note "_cap" i "\" transform=\"translate(" trans_x "," (h+2*thickness+spacing) ")\">"
		print "<path " black_style " d=\""
		print "M0,0"
		print "l" (notch_d+layers*thickness+2*offset) ",0"
		print "l0," thickness
		print "l" (d-2*notch_d-2*offset) ",0"
		print "l0," (-thickness)
		print "l" (notch_d+thickness+2*offset) ",0"
		print "l0," (notch_w+thickness+2*offset)
		print "l" (-thickness) ",0"
		print "l0," (w-2*notch_w-2*offset)
		print "l" thickness ",0"
		print "l0," (notch_w+thickness+2*offset)
		print "l" (-notch_d-thickness-2*offset) ",0"
		print "l0," (-thickness)
		print "l" (-d+2*notch_d+2*offset) ",0"
		print "l0," (thickness)
		print "l" (-notch_d-layers*thickness-2*ofdfset) ",0"
		print "l0," (-notch_w-thickness-2*offset)
		print "l" (layers*thickness) ",0"
		print "l0," (-w+2*notch_w+2*offset)
		print "l" (-layers*thickness) ",0"
		print "Z"
		print "\"/>"
		print "</g>"
		
		outer_d = d+(1+layers)*thickness;
		if( support_d+support_d2+20 > d+(1+layers)*thickness-notch_d && no_support==0) {
			outer_d += 10;
			if( support_d+support_d2+10 > outer_d )
				outer_d = support_d+support_d2+10;
		}
		trans_x += outer_d + spacing;
	}
	print "</g>"
	glob_trans_x += trans_x
}

END {
	print "</svg>";
}
