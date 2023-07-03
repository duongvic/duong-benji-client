require 'benji/client'

benji = Benji::Client.client(url = "http://172.23.8.50:5001/api/v1/benji")

# puts benji.backup.create(volume_id = "3Lv7rPFL", storage_name = "khanhct123" )
#
puts benji.backup.get(3)