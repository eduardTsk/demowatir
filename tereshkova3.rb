require 'minitest/autorun'
require 'watir'

class MainTable < MiniTest::Test
    
    @browser = nil

    def setup
        @browser = Watir::Browser.new :chrome
        @browser.goto 'http://tereshkova.test.kavichki.com/'
    end

    def teardown
        @browser.close
    end

    # проверка работы кнопки Добавить
    #
    def test_input1
        @browser.element(id: 'open').click
        testname = "Genius Portable Loudspeakers"
        @browser.element(xpath: "//input[@id='name']").send_keys(testname)
        @browser.element(xpath: "//input[@id='count']").send_keys("1")
        @browser.element(xpath: "//input[@id='price']").send_keys("150")
        @browser.element(xpath: "//input[@id='add']").click
        
        sell_table = @browser.element(xpath: "//table[@id = 'tbl']")
        sell_rows = sell_table.element(tag_name: "tbody")
        sell_items = sell_rows.elements(tag_name: "tr")

        # после нажатия кнопки Добавить ищем в таблице новый айтем
        added_item = false
        sell_items.each do |row_item|
            row_item.each do |vl|
                if vl.text == testname
                    added_item = true
                    break
                end
            end
        end
        # проверим что новый айтем в таблице
        assert_equal(true, added_item)
    end

    # проверка работы линка Сбросить
    #
    def test_input2
        @browser.element(id: 'open').click
        name = @browser.element(xpath: "//input[@id='name']")
        count = @browser.element(xpath: "//input[@id='count']")
        price = @browser.element(xpath: "//input[@id='price']")
        add_item = @browser.element(xpath: "//input[@id='add']")
        
        # testname = "Genius Portable Loudspeakers"
        name.send_keys("Genius Portable Loudspeakers")
        count.send_keys("1")
        price.send_keys("150")
        add_item.click

        # предпологается что после нажатие на Сбросить поля ввода очищаются
        @browser.element(xpath: "//a[contains(.,'Сбросить')]").click

        # убедимся что поля ввода пусты (кнопка не работает как ожидалось, failure)
        assert_equal('', name.value)
        assert_equal('', count.value)
        assert_equal('', price.value)
    end

    # проверка работы линка Удалить в таблице для нового айтема
    #
    def test_input3
        @browser.element(id: 'open').click
        name = @browser.element(xpath: "//input[@id='name']")
        count = @browser.element(xpath: "//input[@id='count']")
        price = @browser.element(xpath: "//input[@id='price']")
        add_item = @browser.element(xpath: "//input[@id='add']")
        
        sell_table = @browser.element(xpath: "//table[@id = 'tbl']")
        sell_rows = sell_table.element(tag_name: "tbody")
        sell_items = sell_rows.elements(tag_name: "tr")

        # запомним колличество айтемов до апдейта таблицы
        old_count = sell_items.count
        # puts old_count

        # добавим новый айтем
        name.send_keys("Genius Portable Loudspeakers")
        count.send_keys("1")
        price.send_keys("150")
        add_item.click        

        new_count = sell_rows.elements(tag_name: "tr").count
        # пытаемся удалить новый айтем по нажатию на линк Удалить
        sell_items[sell_items.count - 1][3].click

        # определим текущее колличество айтемов
        update_count = sell_rows.elements(tag_name: "tr").count
        
        # текущее и старое значение должны совпасть
        assert_equal(old_count, update_count)
    end
end