from time import sleep
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys

#driver = webdriver.Firefox()
driver = webdriver.Chrome()

driver.get("https://prod-uk-a.online.tableau.com/#/site/acmedashboards/views/SupplyChainDefectsDashbord-Extract9/OutofStock?:iid=1")

try:
    username = WebDriverWait(driver, 15).until(EC.presence_of_element_located((By.ID, "email")))
    username.send_keys('mariakravchenko11@gmail.com')
    driver.find_element(By.ID, 'login-submit').click()

    password = WebDriverWait(driver, 15).until(EC.presence_of_element_located((By.ID, "password")))
    password.send_keys('Password_1')
    driver.find_element(By.ID, 'login-submit').click()

    sleep(5)
    driver.switch_to.frame(0) #(driver.find_element((By.CSS_SELECTOR, "iframe[title=\"Data Visualization\"]")))
    print('Switched to ifame [Data Visualization]')

    bad_timing_button = WebDriverWait(driver, 15).until(EC.element_to_be_clickable((By.CSS_SELECTOR, 'div[title="Navigate to \'Bad Timing\'"]')))
    bad_timing_button.click()
    print('Bad Timing canvas is opened')

    sleep(5)
    fraud_button = WebDriverWait(driver, 15).until(EC.element_to_be_clickable((By.CSS_SELECTOR, 'div[title="Navigate to \'Fraud\'"]')))
    fraud_button.click()
    print('Fraud canvas is opened')

    sleep(5)
    month_filter = WebDriverWait(driver, 15).until(EC.presence_of_element_located((By.CSS_SELECTOR, 'div[class="tabComboBoxButtonHolder"]')))
    month_filter.click()
    driver.find_element(By.XPATH, '//*[contains(@data-test-id, "tabMenuItemName")]').click()
    print('Month filter is opened')

    sleep(2)
    bound_min = WebDriverWait(driver, 15).until(EC.presence_of_element_located((By.CSS_SELECTOR, 'input[aria-label="Lower Bound"]')))
    bound_min.send_keys(Keys.CONTROL + "a")
    sleep(1)
    bound_min.send_keys(Keys.DELETE)
    sleep(1)
    bound_min.send_keys('1500')
    print('Min bounded is edited')

    sleep(2)
    driver.find_element(By.ID, '5738182861_8').click()


except:
    print('Canvases are failed')
    #driver.quit()
#driver.close()
