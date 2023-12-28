# Typical format for SHORE/HOST IP
# SHORE_IP="192.168.1.111"
# HOST_IP="192.168.1.42" # where boat number is 4 (the last 4) and 2 means backseat computer

BOAT_NUMBER = 4


SHORE_IP = "localhost" #Change this to the actual Shoreside IP when deploying on robots
 
boats = { #Change this to the actual host machine IP when deploying on robots
	1:"localhost",
	2:"localhost",
	3:"localhost",
	4:"localhost",
	5:"localhost",
	6:"localhost"
}
#Function: get_boat_ip
# params: boat_number this will be used to return the matching IP addresses for the host/shoreside
#
def get_boat_ip():
	return boats[BOAT_NUMBER]
def get_shore_ip():
	return SHORE_IP