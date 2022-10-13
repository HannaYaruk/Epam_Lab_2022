import time
from time import sleep
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as ec

#Way to web-driver
EXE_PATH = 'd:\chromedriver.exe'
#EMAIL = 'Hanna_Yaruk@epam.com'

#Browser load
driver = webdriver.Chrome(executable_path=EXE_PATH)
driver.get('https://outlook.office.com/')
wait = WebDriverWait(driver, 20)
#time sleep to load the page
time.sleep(5)

#Log in
#login_field = find_element(by=By.XPATH, value=xpath)
login_field = driver.find_element_by_xpath('//input[contains(@type, "email")]')
login_field.send_keys('Hanna_Yaruk@epam.com')
#search_button = driver.find_element_by_css_selector()
#login_field.submit()
time.sleep(1)

next_button = driver.find_element_by_xpath('//input[contains(@type, "submit")]')
next_button.click()

pass_word = wait.until(ec.presence_of_element_located((By.CSS_SELECTOR, 'input[name="Password"]')))
pass_word.send_keys('')
time.sleep(5)

sign_in_button = wait.until(ec.element_to_be_clickable((By.ID, "submitButton")))
sign_in_button.click()

driver.switch_to.frame('duo_iframe')
driver.find_element(By.CSS_SELECTOR, 'div[class="row-label push-label"]>button[type="submit"]').click()
driver.switch_to.default_content()
time.sleep(15)

new_message_button = wait.until(ec.element_to_be_clickable((By.ID, "id__5")))
new_message_button.click()
time.sleep(5)

new_message_to = wait.until(ec.presence_of_element_located((By.CSS_SELECTOR, 'input[aria-label="Кому"]')))
new_message_to.send_keys('Hanna_Yaruk@epam.com')

new_message_subject = wait.until(ec.presence_of_element_located((By.CSS_SELECTOR, 'input[aria-label="Добавьте тему"]')))
new_message_subject.send_keys('Lab work TA')

file = open('D:\Lab_2022\Test_automation_1.py').read()
new_message_body = wait.until(ec.presence_of_element_located((By.CSS_SELECTOR, 'input[aria-label="Текст сообщения"]')))
new_message_body.send_keys(file)

