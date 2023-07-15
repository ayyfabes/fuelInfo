from flask import Blueprint, request, json, jsonify
from .models import Customer, Quote, Profile
from backend import db
from flask_cors import CORS, cross_origin
from .form_validate import QuoteForm, UserProfileForm

views = Blueprint('views', __name__)


# username  email  password
hardcoded_accts = {"Apples": ["jdksf@ymail.com", "12345"], "matcha": ["abc123@gmail.com", "red321"]}

@views.route('/signup', methods=["GET", "POST"])
@cross_origin(supports_credentials=True)
def register():
    print("Useing Sign Up")
    d={}
    # only care anout post for register
    if request.method =="POST":
    
        # need to be edited
        username = request.form["username"]
        password = request.form["password"]
        email = request.form["email"]

        # email = Student.query.filter_by(email=mail).first()

        if username not in hardcoded_accts:
            # add accouuunt
            # register = Student(email=mail, password=password)

            # db.session.add(register)
            # db.session.commit()
            
            hardcoded_accts[username] = [email, password]
            return jsonify(["Register success. Login now"])
        else:
            # already exist
            
            
            return jsonify(["Username already exist"])


@views.route('/login', methods=["GET", "POST"])
def login():
    d = {}
    # handles when customer attempts to login 
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        
        # login = Customer.query.filter_by(email=mail, password=password).first()

        # hardcoded user info
        if username in hardcoded_accts and hardcoded_accts[username][1] == password:
            return jsonify([ "success"])
        else:
            
            return jsonify(["Wrong Credentials"]) 
        
@views.route('/quote', methods=["GET", "POST"])
@cross_origin(supports_credentials=True)
def quote():

    #Post Request
    if request.method == "POST":
        user_id = request.form["user_id"]
        gallons = request.form["gallons"]
        address = request.form["address"]
        date = request.form["date"]
        suggested = request.form["suggested"]
        total = request.form["total"]

        #Backend Validation
        print("Quote Successfully Pulled")
        form = QuoteForm(request.form)
        if form.validate():
            user_id = form.user_id.data
            gallons = form.gallons.data
            address = form.address.data
            date = form.date.data
            suggested = form.suggested.data
            total = form.total.data
            
            db.session.add(Quote(user_id = user_id, gallons = gallons, address = address, date = date, suggested = suggested, total = total))
            db.session.commit()
            print("Quote Successfully Created")

            return jsonify([ "Fuel Quote created"])
        
        else:
            print("Quote Failed Validation")
            errors = form.errors
            return jsonify([str(errors)])

@views.route('/profileCreation', methods=["GET", "POST"])
@cross_origin(supports_credentials=True)
def profileCreation():
    if request.method == "POST":
        user_id = request.form["user_id"]
        fullname = request.form["fullname"]
        address1 = request.form["address1"]
        address2 = request.form["address2"]
        city = request.form["city"]
        stateCode = request.form["stateCode"]
        zipcode = request.form["zipcode"]

        #Backend Validation
        print("Profile Successfully Pulled")
        form = UserProfileForm(request.form)
        if form.validate():
            user_id = form.user_id.data
            fullname = form.fullname.data
            address1 = form.address1.data
            address2 = form.address2.data
            city = form.city.data
            stateCode = form.stateCode.data
            zipcode = form.zipcode.data

            db.session.add(Profile(user_id = user_id, fullname = fullname, address1 = address1, address2 = address2, city = city, stateCode = stateCode, zipcode = zipcode))
            db.session.commit()
            print("Profile Successfully Created")

            return jsonify([ "Profile created"])

        else:
            print("Profile Failed Validation")
            errors = form.errors
            return jsonify([str(errors)])
           
