require 'nokogiri'
require 'uri'

class Scraper
  def process(text)
    doc = Nokogiri::HTML(text)
    result = ScrapeResult.new
    result.id = doc.css('div.prog-preview').css('a').first['href'].split('=').last.to_i
    result.title = doc.css('div.prog-preview').css('div.news-category-title').first.text
    result.description = doc.css('div.prog-preview').css('div.prog-descr').first.text.strip
    result.image = doc.css('div.prog-preview').css('img').first['src']
    result.link = URI.join('https://ukr.radio', doc.css('div.prog-preview').css('a').first['href']).to_s
    result.items = []
    result.items += process_items(text)
    result
  end

  def process_items(text)
    doc = Nokogiri::HTML(text)
    doc.css('div.program-item').map do |item|
      podcast_item = PodcastItem.new
      control_div = item.css('div.program-item-controls').first.css('div')
      podcast_item.title = item.css('div.program-item-content').css('div').css('p').first.text
      podcast_item.link = URI.join('https://ukr.radio', control_div.first['data-media-path']).to_s
      podcast_item.description = item.css('div.program-item-content').css('div').css('p').first.text
      podcast_item.updated =
        control_div.first['data-media-date'] + ' ' + control_div.first['data-media-time']
      podcast_item
    end
  end
end

ScrapeResult = Struct.new(:id, :title, :link, :description, :image, :items)
PodcastItem = Struct.new(:title, :link, :description, :updated, :pubDate)
# <div class="prog-preview">
#
#         <div class="news-category-title">Антологія. Український альбом</div>
#         <img src="/images/bank/prog/size2/prog_1677012664_63f52eb89de6d.png" alt="Антологія. Український альбом" />
#
#     <div class="prog-descr">
#         <p style="text-align: justify;">Історія становлення українського шоу-бізнесу у персоналіях.</p>
#     </div>
#
#     <div class="spacer"></div>
#
#     <div class="news-category-title mt20">Передачі з архіву</div>
# <div data-media-container class="programs-list radio-2">
#
# <div class="program-item">
#     <img src="/images/bank/prog/size2/prog_1677012664_63f52eb89de6d.png" alt="" class="program-item-image">
#     <div class="program-item-controls">
#         <div data-media-picture="/images/bank/prog/size2/prog_1677012664_63f52eb89de6d.png" data-media-item data-media-date="03.11.2021" data-media-time="19:04:03" data-media-channel="Промінь" data-media-title="Антологія. Український альбом" data-media-path="/audio_slice/AIR-UR2/20211103/2979820.mp3" class="program-item-btn"></div>
#     </div>
#     <div class="program-item-content">
#         <div class="program-date">03.11.2021 19:04:03 <a href="/prog.html?id=604">Антологія. Український альбом</a></div>
#         <div class="socials">
#             <a href="https://www.facebook.com/sharer/sharer.php?u=http://ukr.radio/schedule/play-archive.html?periodItemID=2979820" target="_blank" class="facebook"></a>
#             <a href="https://twitter.com/intent/tweet?text=Антологія. Український альбом&url=http://ukr.radio/schedule/play-archive.html?periodItemID=2979820" target="_blank" class="twitter"></a>
#             <a href="viber://forward?text=http://ukr.radio/schedule/play-archive.html?periodItemID=2979820" target="_blank" class="viber"></a>
#             <a href="https://t.me/share/url?url=http://ukr.radio/schedule/play-archive.html?periodItemID=2979820&text=Антологія. Український альбом" target="_blank" class="telegram"></a>
#             <a href="" target="" onclick="aux = document.createElement('input');aux.setAttribute('value', 'http://ukr.radio/schedule/play-archive.html?periodItemID=2979820');document.body.appendChild(aux);aux.select();document.execCommand('copy');document.body.removeChild(aux);alert('Посилання скопійовано в буфер');event.preventDefault()" class="link"></a>
#         </div>
#         <div><p>Юркеш &ldquo;Менуети&rdquo; 2007</p></div>
#         <div>
#
#              Ведучі:            <a class="program-speaker" href="/prog-presenter.html?id=309">Світлана Берестовська</a>
#                                 </div>
#     </div>
# </div>
#
#
# <div class="program-item">
#     <img src="/images/bank/prog/size2/prog_1677012664_63f52eb89de6d.png" alt="" class="program-item-image">
#     <div class="program-item-controls">
#         <div data-media-picture="/images/bank/prog/size2/prog_1677012664_63f52eb89de6d.png" data-media-item data-media-date="27.10.2021" data-media-time="19:04:01" data-media-channel="Промінь" data-media-title="Антологія. Український альбом" data-media-path="/audio_slice/AIR-UR2/20211027/2974216.mp3" class="program-item-btn"></div>
#     </div>
#     <div class="program-item-content">
#         <div class="program-date">27.10.2021 19:04:01 <a href="/prog.html?id=604">Антологія. Український альбом</a></div>
#         <div class="socials">
#             <a href="https://www.facebook.com/sharer/sharer.php?u=http://ukr.radio/schedule/play-archive.html?periodItemID=2974216" target="_blank" class="facebook"></a>
#             <a href="https://twitter.com/intent/tweet?text=Антологія. Український альбом&url=http://ukr.radio/schedule/play-archive.html?periodItemID=2974216" target="_blank" class="twitter"></a>
#             <a href="viber://forward?text=http://ukr.radio/schedule/play-archive.html?periodItemID=2974216" target="_blank" class="viber"></a>
#             <a href="https://t.me/share/url?url=http://ukr.radio/schedule/play-archive.html?periodItemID=2974216&text=Антологія. Український альбом" target="_blank" class="telegram"></a>
#             <a href="" target="" onclick="aux = document.createElement('input');aux.setAttribute('value', 'http://ukr.radio/schedule/play-archive.html?periodItemID=2974216');document.body.appendChild(aux);aux.select();document.execCommand('copy');document.body.removeChild(aux);alert('Посилання скопійовано в буфер');event.preventDefault()" class="link"></a>
#         </div>
#         <div><p>Pianoбой Альбом &quot;Хісторі&quot; - 2019 рік</p></div>
#         <div>
#
#              Ведучі:            <a class="program-speaker" href="/prog-presenter.html?id=309">Світлана Берестовська</a>
#                                 </div>
#     </div>
# </div>
#
