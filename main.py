# import mysql.connector
import telebot
from telebot import types



bot = telebot.TeleBot('6860656556:AAFidoSHZvC5dsFq7BKiBMSnyqyJP9dFwIk');

@bot.message_handler(commands=['start'])
def start(message):
    # connection = mysql.connector.connect(
    #     user='root', password='root', host='db', port="3306", database='db')
    # print("DB connected")

    # cursor = connection.cursor()
    # cursor.execute('select ID, is_valid_place, code_place from wp_place')
    # students = cursor.fetchall()
    # connection.close()

    markup = types.InlineKeyboardMarkup()
    markup.add(types.InlineKeyboardButton('Google', url='https://www.google.com/'))

    bot.send_message(message.chat.id, "DB connected", reply_markup=markup)

bot.polling(non_stop=True)