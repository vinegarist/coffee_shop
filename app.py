from flask import Flask, render_template, request, redirect, url_for, session
import mysql.connector
from datetime import datetime

app = Flask(__name__, static_url_path='/static')

app.secret_key = 'your_secret_key'

# MySQL 配置
db = mysql.connector.connect(
    host='localhost',
    user='root',
    password='root',
    database='coffee_shop'
)


# 登录路由
@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
        user = cursor.fetchone()

        if user and user['password_hash'] == password:
            session['user_id'] = user['id']
            if user['role'] == 'owner':
                return redirect(url_for('owner_dashboard'))
            elif user['role'] == 'customer':
                return redirect(url_for('customer_dashboard'))
        else:
            error = 'Invalid username or password'
            return render_template('login.html', error=error)
    return render_template('login.html')


# 登出路由
@app.route('/logout')
def logout():
    session.pop('user_id', None)
    return redirect(url_for('login'))


# 管理员仪表板路由
@app.route('/owner_dashboard')
def owner_dashboard():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM coffees")
    coffees = cursor.fetchall()
    cursor.execute("SELECT * FROM orders")
    orders = cursor.fetchall()
    cursor.execute("SELECT * FROM points")
    user_points = cursor.fetchall()

    return render_template('owner_dashboard.html', coffees=coffees, orders=orders, user_points=user_points)


# 更新咖啡数量路由
@app.route('/update_quantity/<int:coffee_id>', methods=['POST'])
def update_quantity(coffee_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))

    quantity_change = int(request.form['quantity'])

    cursor = db.cursor(dictionary=True)
    cursor.execute("UPDATE coffees SET quantity = quantity + %s WHERE id = %s", (quantity_change, coffee_id))
    db.commit()
    cursor.close()

    return redirect(url_for('owner_dashboard'))


# 添加咖啡路由
@app.route('/add_coffee', methods=['POST'])
def add_coffee():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    name = request.form['name']
    price = float(request.form['price'])
    quantity = int(request.form['quantity'])

    cursor = db.cursor(dictionary=True)
    cursor.execute("INSERT INTO coffees (name, price, quantity) VALUES (%s, %s, %s)", (name, price, quantity))
    db.commit()
    cursor.close()

    return redirect(url_for('owner_dashboard'))


# 删除咖啡路由
@app.route('/delete_coffee/<int:coffee_id>', methods=['POST'])
def delete_coffee(coffee_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))

    cursor = db.cursor(dictionary=True)
    cursor.execute("DELETE FROM coffees WHERE id = %s", (coffee_id,))
    db.commit()
    cursor.close()

    return redirect(url_for('owner_dashboard'))


# 客户仪表板路由
@app.route('/customer_dashboard', methods=['GET', 'POST'])
def customer_dashboard():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    if request.method == 'POST':
        coffee_id = int(request.form['coffee_id'])
        quantity = int(request.form['quantity'])
        temperature = request.form['temperature']

        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM coffees WHERE id = %s", (coffee_id,))
        coffee = cursor.fetchone()

        if coffee and coffee['quantity'] >= quantity:
            total_price = coffee['price'] * quantity
            cursor.execute(
                "INSERT INTO orders (user_id, coffee_id, quantity, total_price, order_date, temperature) VALUES (%s, %s, %s, %s, NOW(), %s)",
                (session['user_id'], coffee_id, quantity, total_price, temperature))
            db.commit()
            cursor.execute("UPDATE coffees SET quantity = quantity - %s WHERE id = %s", (quantity, coffee_id))
            db.commit()

            # 根据订单总价更新积分
            cursor.execute("UPDATE points SET points = points + %s WHERE user_id = %s",
                           (total_price, session['user_id']))
            db.commit()

            order_success = True
        else:
            order_success = False

        cursor.execute("SELECT * FROM points WHERE user_id = %s", (session['user_id'],))
        points = cursor.fetchone()

        cursor.execute("SELECT * FROM coffees")
        coffees = cursor.fetchall()

        # 获取当前用户的订单
        cursor.execute("SELECT * FROM orders WHERE user_id = %s", (session['user_id'],))
        orders = cursor.fetchall()

        return render_template('customer_dashboard.html', points=points, coffees=coffees, orders=orders,
                               order_success=order_success)

    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM points WHERE user_id = %s", (session['user_id'],))
    points = cursor.fetchone()

    cursor.execute("SELECT * FROM coffees")
    coffees = cursor.fetchall()

    # 获取当前用户的订单
    cursor.execute("SELECT * FROM orders WHERE user_id = %s", (session['user_id'],))
    orders = cursor.fetchall()

    return render_template('customer_dashboard.html', points=points, coffees=coffees, orders=orders, order_success=None)


# 注册路由
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
        user = cursor.fetchone()

        if user:
            error = 'Username already exists'
            return render_template('register.html', error=error)
        else:
            cursor.execute("INSERT INTO users (username, password_hash, role) VALUES (%s, %s, 'customer')",
                           (username, password))
            db.commit()
            return redirect(url_for('login'))

    return render_template('register.html', error=None)


# 增加会员卡路由
@app.route('/add_membership_card', methods=['GET', 'POST'])
def add_membership_card():
    if request.method == 'POST':
        card_number = request.form['card_number']
        expiration_date = request.form['expiration_date']
        membership_level = request.form['membership_level']
        user_id = request.form['user_id']

        cursor = db.cursor(dictionary=True)
        cursor.execute(
            "INSERT INTO membership_card (card_number, expiration_date, membership_level, user_id) VALUES (%s, %s, %s, %s)",
            (card_number, expiration_date, membership_level, user_id))
        db.commit()
        cursor.close()

        return redirect(url_for('owner_dashboard'))
    return render_template('add_membership_card.html')


# 查看会员卡路由
@app.route('/view_membership_card/<int:user_id>')
def view_membership_card(user_id):
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM membership_card WHERE user_id = %s", (user_id,))
    card = cursor.fetchone()
    cursor.close()
    return render_template('view_membership_card.html', card=card)


# 查看所有会员卡路由
@app.route('/view_all_membership_cards')
def view_all_membership_cards():
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM membership_card")
    cards = cursor.fetchall()
    cursor.close()
    return render_template('view_all_membership_cards.html', cards=cards)
# 查看所有订单路由
@app.route('/view_orders')
def view_orders():
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM orders")
    orders = cursor.fetchall()
    cursor.close()
    return render_template('view_orders.html', orders=orders)

if __name__ == "__main__":
    app.run(debug=True)
