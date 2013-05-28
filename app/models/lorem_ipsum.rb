class LoremIpsum

  CORPUS = %w(
    accumsan accusamus accusantium adipiscing adipisicing aenean alias aliqua aliquam
    aliquet aliquid aliquip amet anim animi aperiam architecto arcu asperiores aspernatur
    assumenda auctor augue beatae bibendum blandit blanditiis cillum commodi commodo
    condimentum congue consectetur consequat consequatur consequuntur convallis corporis
    corrupti cras culpa cupidatat cupiditate curabitur cursus dapibus debitis delectus
    deleniti deserunt diam dicta dictum dignissim dignissimos distinctio dolor dolore
    dolorem doloremque dolores doloribus dolorum done ducimus duis earum egesta eleif
    eligendi esse eveniet excepteur excepturi exercitation exercitationem expedita
    explicabo facere facilis faucibus felis fermentum feugiat fringilla fuga fugiat fugit
    harum hendrerit iaculis illo illum impedit imperdiet incididunt integer interdum
    inventore ipsa ipsum irure iste itaque iure iusto justo labore laboriosam laboris
    laborum labret lacinia lacus laudantium lectus leo libero ligula lobortis lorem luctus
    maecenas magna magnam magni maiores malesuada massa mattis mauris maxime metus minim
    minima minus modi molestiae molestias molestie mollit mollitia morbi natus
    necessitatibus nemo nesciunt nihil nisi nobis non nostrud nostrum nulla nullam numquam
    obcaecati occaecat odio odit officia officiis omnis optio orci ornare pariatur
    pellentesque perferendis perspiciatis pharetra placeat placerat porro porta porttitor
    possimus potenti praesent praesentium pretium proident proin provident pulvinar purus
    quasi quibusdam ratione recusandae reiciendis repellat repellendus reprehenderit
    repudiandae rerum rhoncus risus rutrum saepe sagittis sapien sapiente scelerisque sequi
    similique sollicitudin soluta suscipit suspendisse tellus tempor tempora tempore
    temporibus tempus tenetur tincidunt totam tristique turpis ullam ullamco ullamcorper
    ultricies unde urna varius vehicula venenatis veniam veritatis vero vestibulum vitae
    vivamus voluptas voluptate voluptatem voluptates voluptatibus voluptatum volutpat
    vulputate
  )
  CONNECTORS = %w(
    a ab ac ad ante at atque aut aute autem cum cumque dui duis ea eaque eget eis eius
    eiusmod elit enim eos erat est et etia eu euismod eum ex hic id in mi nam nec neque
    nisi non nunc quae quaerat quam quas qui quia quidem quis quisue quisquam quo quod quos
    rem sed sem semper sint sit sunt ut vel velit
  )
  LIDSACAE = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '

  def self.word(corpus=CORPUS)
    corpus.sample
  end

  def self.phrase(connectors=CONNECTORS)
    words = LoremIpsum.construct(lambda{LoremIpsum.word}, 2, 6)
    if rand(3) > 0
      words.insert(rand(words.count), connectors.sample)
    else
      words
    end.join(' ')
  end

  def self.sentence
    LoremIpsum.construct(lambda{LoremIpsum.phrase}, 1, 4, ', ') do |sentence|
      sentence.capitalize
    end
  end

  def self.paragraph
    LoremIpsum.construct(lambda{LoremIpsum.sentence}, 3, 10, '. ')
  end

#  private

  def self.construct(constituent, min_length, max_length, joiner=nil)
    list = []

    length = rand(max_length - min_length) + min_length
    while list.length < length do
      piece = constituent.call
      #piece = LoremIpsum.send(constituent)
      list.push(piece) unless piece == list.last
    end

    retval = if joiner
               list.join(joiner)
             else
               list
             end

    if block_given?
      yield retval
    else
      retval
    end
  end

end

