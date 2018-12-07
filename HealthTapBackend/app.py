import Flask
import pymongo

app = Flask(__name__)

myclient = pymongo.connectClient("mongodb://localhost:27017/")

users = myclient["users"]

"""
	users = { name: String, email: String }
"""

medicines = myclient["medicineDB"]

"""
{
	company: String
	name: String,
	salt: String,
	expiry: Date,
	donator: String
} """


blood_banks = myclient["bloodyschema"]

""" 
	{
		blood_group: String,
		donator: String,
		donated_bank: String,
		bank_location: geological_data
	}
"""


@app.route("/get_user/<email>", methods=["POST"])
def get_user(email):
	return users.find_one({ "email" : email})


@app.route("/set_user/<metadata>", methods=["POST"])
def save_user(metadata):
	fields = list(metadata.split("#"))
	query = { "name": fields[0], "email" : fields[1]}
	return "successful!"


@app.route("/search_medicine/<metadata>", methods=["POST"])
def find_medicine(metadata):
	fields = list(metadata.split("@"))
	query = {}
	if fields[0] is not '':
		query["company"] = fields[0]
	if fields[1] is not '':
		query["name"] = fields[1]
	if fields[2] is not '':
		query["salt"] = fields[2]
	medikit = medicines.find(query)
	# SORT ACCORDING to expiry DATE
	return medikit


@app.route("/save_medicine/<metadata>", methods=["POST"])
def save_medicine(metadata):
	fields = list(metadata.split("@"))
	query = {}
	if fields[0] is not '':
		query["company"] = fields[0]
	if fields[1] is not '': 
		query["name"] = fields[1]
	if fields[2] is not '':
		query["salt"] = fields[2]
	
	query["expiry"] = fields[3]
	query["expiry"] = fields[4]  # convert to date here
	medicines.insert_one(query)
	return "successful"


@app.route("/get_blood/<metadata>", methods=["POST"])
def get_blood(metadata):
	fields = list(metadata.split("@")) 
	current_location = fields[2]
	results = blood_banks.find({ "blood_group" : fields[0] })
	# sort results in increasing order of distance
	return results
	

@app.route("/save_blood/<metadata>", methods=["POST"])
def save_blood(metadata):
	fields = list(metadata.split("@"))
	query = {}
	query["blood_group"] = fields[0]
	query["donated_bank"] = fields[1]
	query["bank_location"] = fields[2]
	query["donator"] = fields[3]
	blood_banks.insert_one(query)
	return "Successful!"


if __name__ == "__main__":
	app.run(debug=True)
