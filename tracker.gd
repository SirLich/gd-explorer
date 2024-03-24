@tool
extends Node

var calls = {}
var totals = {}
var current = {}
var total = 0

func time():
	return Time.get_ticks_usec()
	
func push(k):
	current[k] = time()

func pop(k):
	if not calls.has(k):
		calls[k] = []
		totals[k] = 0
	var new_time = time() - current[k]
	calls[k].append(new_time)
	totals[k] = totals[k] + new_time
	total += new_time
	
func do_report():
	print("-----")
	for k in calls:
		var v : Array = calls[k]
		print("F: %s, %d, %f" % [k, v.size(), totals[k]/1000000.0])
	print(total)
	calls = {}
	totals = {}
	current = {}
	total = 0
