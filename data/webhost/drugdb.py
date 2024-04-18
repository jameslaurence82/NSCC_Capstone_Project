"""
Creation of the Drug Interaction Database Python Webserver
Author: James Laurence
Team Members:
Chris Whalen
Louise Fear
Gabriela Mkonde
James Laurence
Date: April 8th, 2024
INFT3000
"""

from flask import Flask, request, render_template
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# app.config['SQLALCHEMY_DATABASE_URI'] = 'mssql+pyodbc://@GABBY/drugDB?trusted_connection=yes&driver=ODBC+Driver+17+for+SQL+Server'
app.config['SQLALCHEMY_DATABASE_URI'] = 'mssql+pyodbc://@MSI/drugDB?trusted_connection=yes&driver=ODBC+Driver+17+for+SQL+Server'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class Drug(db.Model):
    __tablename__ = 'DRUG'
    DRUG_ID = db.Column(db.String(10), primary_key=True)
    DRUG_Name = db.Column(db.String(255), nullable=False)

class Product(db.Model):
    __tablename__ = 'PRODUCT'
    PRO_ID = db.Column(db.Integer, primary_key=True)
    FK_DRUG_ID = db.Column(db.String(10), db.ForeignKey('DRUG.DRUG_ID'), nullable=False)
    PRO_GenericName = db.Column(db.String)

class DrugInteraction(db.Model):
    __tablename__ = 'DRUG_INTERACTION'
    FK_DRUG_ID = db.Column(db.String(10), db.ForeignKey('DRUG.DRUG_ID'), primary_key=True)
    INTER_DrugID = db.Column(db.String(10), primary_key=True)
    INTER_Description = db.Column(db.String(255), nullable=False)

class FoodInteraction(db.Model):
    __tablename__ = 'FOOD_INTERACTION'
    FK_DRUG_ID = db.Column(db.String(10), db.ForeignKey('DRUG.DRUG_ID'), primary_key=True)
    FOOD_Description = db.Column(db.String)

@app.route('/', methods=['GET', 'POST'])
def index():
    drug_interaction_info = "No Known Drug Interactions"
    food_interaction_info = "No Known Food Interactions"
    drug_name1 = ''
    drug_name2 = ''
    
    if request.method == 'POST':
        drug_name1 = request.form.get('drug_name1').strip()
        drug_name2 = request.form.get('drug_name2').strip()
        check_for_food = request.form.get('food_checkbox') == 'on'

        # Debugging output
        print(f"Input Drug 1: {drug_name1}, Drug 2: {drug_name2}, Check for food interactions: {check_for_food}")

        # Query for the drugs by name or generic name
        drug1_id = get_drug_id(drug_name1)
        drug2_id = get_drug_id(drug_name2)

        # Debugging output
        print(f"Found Drug IDs - Drug 1: {drug1_id}, Drug 2: {drug2_id}")

        if drug1_id and drug2_id:
            # Query for drug interactions
            drug_interaction_info = get_drug_interaction(drug1_id, drug2_id)

        if check_for_food and drug1_id:
            # Query for food interactions
            food_interaction_info = get_food_interaction(drug1_id)

    return render_template('index.html',
        drug_name1=drug_name1,
        drug_name2=drug_name2,
        drug_interaction_info=drug_interaction_info or "No Known Drug Interactions",
        food_interaction_info=food_interaction_info or "No Known Food Interactions")

def get_drug_id(drug_name):
    """Function to fetch a drug's ID by its official or generic name."""
    drug = Drug.query.filter_by(DRUG_Name=drug_name).first()
    if drug:
        return drug.DRUG_ID
    else:
        product = Product.query.filter_by(PRO_GenericName=drug_name).first()
        return product.FK_DRUG_ID if product else None

def get_drug_interaction(drug1_id, drug2_id):
    """Function to fetch a description of any interaction between two drugs."""
    interaction = DrugInteraction.query.filter(
        ((DrugInteraction.FK_DRUG_ID == drug1_id) & (DrugInteraction.INTER_DrugID == drug2_id)) |
        ((DrugInteraction.FK_DRUG_ID == drug2_id) & (DrugInteraction.INTER_DrugID == drug1_id))
    ).first()
    return interaction.INTER_Description if interaction else "No Known Drug Interactions"

def get_food_interaction(drug_id):
    """Function to fetch a description of any food interaction for a drug."""
    food_interaction = FoodInteraction.query.filter_by(FK_DRUG_ID=drug_id).first()
    return food_interaction.FOOD_Description if food_interaction else "No Known Food Interactions"

if __name__ == '__main__':
    app.run(debug=True)