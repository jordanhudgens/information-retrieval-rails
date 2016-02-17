class ApiQuery
  def initialize
  	@api_root = "http://api.stackexchange.com"
  	@answers = HTTParty.get(@api_root + '/2.2/answers?site=stackoverflow')
  end

  def output_answers
    @answers.to_dish.items
  end

  def question_generator(question_id)
    question_data = get_specific_question_in_json(question_id).to_dish.items
    question_data.each do |question|
      add_question_to_database(
        tags: question.tags,
        link: question.link,
        creation_date: question.creation_date,
        title: question.title,
        question_id: question.question_id
      )
    end
  end

  def add_answer_to_database(reputation, user_id, profile_image, display_name, profile_link, answer_id, question_id)
    return if Answer.find_by(question_id: question_id)
    Answer.create!(
      reputation: reputation,
      user_id: user_id,
      profile_image: profile_image,
      display_name: display_name,
      profile_link: profile_link,
      answer_id: answer_id,
      question_id: question_id
    )
  end

  def get_specific_question_in_json(question_id)
    HTTParty.get(@api_root + "/2.2/questions/#{question_id}?order=desc&sort=activity&site=stackoverflow")
  end

  def add_question_to_database(tags: tags, link: link, creation_date: creation_date, title: title, question_id: question_id)
    return if Question.find_by(question_id: question_id)
    Question.create!(
      tags: tags,
      link: link,
      creation_date: creation_date,
      title: title,
      question_id: question_id
    )
  end

  def generator
    output_answers.each do |answer|
      add_answer_to_database(answer.owner.reputation, answer.owner.user_id, answer.owner.profile_image, answer.owner.display_name, answer.owner.link, answer.question_id, answer.answer_id)
      question_generator(answer.question_id)
    end
  end

  # pseudo code for data acquisition algorithm

  # Contact the stackexchange API via scheduled, background job

  # Get the past day's list of answers

  # Query the local db to see if the question ID exists

  # If the question ID does not exist it calls the `get_specific_question_in_json`

  # It then creates a new entry for that question in the db

  # There is a relational connection between question and answers

  # The goal of having answers queried is this:

  ## It will give better historical question results

  ## They can be used to gauge popularity

  ## If we only queried the question API we'd only get new questions and miss out on historical questions (arguably the more important questions)

  # Sample API Output for answers

  # Question.create!(tags: tags, link: link, creation_date: creation_date, title: title)

  # Answer.create!(reputation: , user_id: , profile_image: , display_name: , profile_link: , question_id: )

  # reputation:string user_id:string profile_image:text display_name:string profile_link:text question_id:string

  # Question:  => [#<Dish::Plate:0x007fdd5a091bb0 @_original_hash={"tags"=>["c++"], "owner"=>{"reputation"=>1, "user_id"=>3950834, "user_type"=>"registered", "profile_image"=>"https://www.gravatar.com/avatar/79fe62a791b9b968eaef89adeb01d712?s=128&d=identicon&r=PG&f=1", "display_name"=>"bob smith", "link"=>"http://stackoverflow.com/users/3950834/bob-smith"}, "is_answered"=>true, "view_count"=>19, "answer_count"=>2, "score"=>0, "last_activity_date"=>1455741938, "creation_date"=>1455740672, "question_id"=>35466987, "link"=>"http://stackoverflow.com/questions/35466987/linked-list-not-printing-the-value-what-am-i-doing-wrong", "title"=>"Linked list not printing the value? What am i doing wrong"}, @_value_cache={}>]

  # "{\"items\":[{\"owner\":{\"reputation\":1656,\"user_id\":5741460,\"user_type\":\"registered\",\"profile_image\":\"https://lh5.googleusercontent.com/-oxgS1vLh9Co/AAAAAAAAAAI/AAAAAAAAAAA/5hRLB7BLWWA/photo.jpg?sz=128\",\"display_name\":\"Yoav Glazner\",\"link\":\"http://stackoverflow.com/users/5741460/yoav-glazner\"},\"is_accepted\":true,\"score\":0,\"last_activity_date\":1455572732,\"last_edit_date\":1455572732,\"creation_date\":1455515373,\"answer_id\":35402303,\"question_id\":35401169},

  #{\"owner\":{\"reputation\":2223,\"user_id\":2780791,\"user_type\":\"registered\",\"accept_rate\":60,\"profile_image\":\"https://www.gravatar.com/avatar/1feea731a99cb95e342d196802bb868a?s=128&d=identicon&r=PG&f=1\",\"display_name\":\"Alexei\",\"link\":\"http://stackoverflow.com/users/2780791/alexei\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572732,\"last_edit_date\":1455572732,\"creation_date\":1455565773,\"answer_id\":35417849,\"question_id\":35417391},{\"owner\":{\"reputation\":1336,\"user_id\":807126,\"user_type\":\"registered\",\"profile_image\":\"https://i.stack.imgur.com/C7jLB.jpg?s=128&g=1\",\"display_name\":\"Doug Stevenson\",\"link\":\"http://stackoverflow.com/users/807126/doug-stevenson\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572723,\"creation_date\":1455572723,\"answer_id\":35419686,\"question_id\":35419634},{\"owner\":{\"reputation\":89569,\"user_id\":48015,\"user_type\":\"registered\",\"accept_rate\":80,\"profile_image\":\"https://www.gravatar.com/avatar/0b722a5f7d2d809629ee40c63cc8576b?s=128&d=identicon&r=PG\",\"display_name\":\"Christoph\",\"link\":\"http://stackoverflow.com/users/48015/christoph\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572722,\"creation_date\":1455572722,\"answer_id\":35419685,\"question_id\":35419461},{\"owner\":{\"reputation\":29699,\"user_id\":5696608,\"user_type\":\"registered\",\"accept_rate\":86,\"profile_image\":\"https://www.gravatar.com/avatar/82086984779cd4c215e63edc1d1b7731?s=128&d=identicon&r=PG\",\"display_name\":\"Tom H\",\"link\":\"http://stackoverflow.com/users/5696608/tom-h\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572714,\"creation_date\":1455572714,\"answer_id\":35419683,\"question_id\":35419581},{\"owner\":{\"reputation\":6382,\"user_id\":3282056,\"user_type\":\"registered\",\"profile_image\":\"https://i.stack.imgur.com/IXonK.jpg?s=128&g=1\",\"display_name\":\"rcgldr\",\"link\":\"http://stackoverflow.com/users/3282056/rcgldr\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572709,\"last_edit_date\":1455572709,\"creation_date\":1455572406,\"answer_id\":35419589,\"question_id\":35419226},{\"owner\":{\"reputation\":11,\"user_id\":4735510,\"user_type\":\"registered\",\"profile_image\":\"https://www.gravatar.com/avatar/1bae9be2bb87ed998d360aaf636b3f96?s=128&d=identicon&r=PG&f=1\",\"display_name\":\"NewToMint\",\"link\":\"http://stackoverflow.com/users/4735510/newtomint\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572703,\"creation_date\":1455572703,\"answer_id\":35419679,\"question_id\":35419551},{\"owner\":{\"reputation\":76571,\"user_id\":1175966,\"user_type\":\"registered\",\"profile_image\":\"https://www.gravatar.com/avatar/8d3d9dfbd040f9cbc1a6b82f0da2b345?s=128&d=identicon&r=PG\",\"display_name\":\"charlietfl\",\"link\":\"http://stackoverflow.com/users/1175966/charlietfl\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572702,\"creation_date\":1455572702,\"answer_id\":35419678,\"question_id\":35419484},{\"owner\":{\"reputation\":4291,\"user_id\":5091073,\"user_type\":\"registered\",\"profile_image\":\"https://www.gravatar.com/avatar/d1cae416e3ac456b5b33b54438f7f4dc?s=128&d=identicon&r=PG&f=1\",\"display_name\":\"Nir Levy\",\"link\":\"http://stackoverflow.com/users/5091073/nir-levy\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572701,\"creation_date\":1455572701,\"answer_id\":35419676,\"question_id\":35419581},{\"owner\":{\"reputation\":760,\"user_id\":1027762,\"user_type\":\"registered\",\"accept_rate\":73,\"profile_image\":\"https://www.gravatar.com/avatar/69a74dc300fc6c99ea8d3361705964d0?s=128&d=identicon&r=PG\",\"display_name\":\"mic\",\"link\":\"http://stackoverflow.com/users/1027762/mic\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572692,\"last_edit_date\":1455572692,\"creation_date\":1455572331,\"answer_id\":35419568,\"question_id\":35419168},{\"owner\":{\"reputation\":1,\"user_id\":5932112,\"user_type\":\"unregistered\",\"profile_image\":\"https://www.gravatar.com/avatar/aa851767d667369689362ef9340be7a1?s=128&d=identicon&r=PG\",\"display_name\":\"george\",\"link\":\"http://stackoverflow.com/users/5932112/george\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572685,\"creation_date\":1455572685,\"answer_id\":35419675,\"question_id\":3663439},{\"owner\":{\"reputation\":1312,\"user_id\":954930,\"user_type\":\"registered\",\"accept_rate\":93,\"profile_image\":\"https://i.stack.imgur.com/1pEmC.png?s=128&g=1\",\"display_name\":\"ItsGreg\",\"link\":\"http://stackoverflow.com/users/954930/itsgreg\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572680,\"creation_date\":1455572680,\"answer_id\":35419674,\"question_id\":35419484},{\"owner\":{\"reputation\":671,\"user_id\":1268048,\"user_type\":\"registered\",\"accept_rate\":95,\"profile_image\":\"https://i.stack.imgur.com/naEf9.jpg?s=128&g=1\",\"display_name\":\"Phil\",\"link\":\"http://stackoverflow.com/users/1268048/phil\"},\"is_accepted\":false,\"score\":1,\"last_activity_date\":1455572676,\"last_edit_date\":1455572676,\"creation_date\":1455553568,\"answer_id\":35414285,\"question_id\":35414209},{\"owner\":{\"reputation\":1,\"user_id\":5589139,\"user_type\":\"registered\",\"profile_image\":\"https://www.gravatar.com/avatar/6fec7af3d38045e7d1d17df175f654a2?s=128&d=identicon&r=PG&f=1\",\"display_name\":\"christianlehmann\",\"link\":\"http://stackoverflow.com/users/5589139/christianlehmann\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572661,\"creation_date\":1455572661,\"answer_id\":35419670,\"question_id\":35393058},{\"owner\":{\"reputation\":801,\"user_id\":3175061,\"user_type\":\"registered\",\"profile_image\":\"https://www.gravatar.com/avatar/7b768b3ec230b98c66fe106d24ab32de?s=128&d=identicon&r=PG&f=1\",\"display_name\":\"David E. Jones\",\"link\":\"http://stackoverflow.com/users/3175061/david-e-jones\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572652,\"creation_date\":1455572652,\"answer_id\":35419669,\"question_id\":35407635},{\"owner\":{\"reputation\":173,\"user_id\":5884372,\"user_type\":\"registered\",\"profile_image\":\"https://lh5.googleusercontent.com/-G6dkc2pwEso/AAAAAAAAAAI/AAAAAAAAAus/rpn94Od3ACo/photo.jpg?sz=128\",\"display_name\":\"Janek Bevendorff\",\"link\":\"http://stackoverflow.com/users/5884372/janek-bevendorff\"},\"is_accepted\":false,\"score\":1,\"last_activity_date\":1455572651,\"last_edit_date\":1455572651,\"creation_date\":1455571932,\"answer_id\":35419476,\"question_id\":35377978},{\"owner\":{\"reputation\":1,\"user_id\":3186007,\"user_type\":\"registered\",\"profile_image\":\"https://www.gravatar.com/avatar/f4d14f6ff6325bdc756407a01a45c27a?s=128&d=identicon&r=PG&f=1\",\"display_name\":\"user3186007\",\"link\":\"http://stackoverflow.com/users/3186007/user3186007\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572645,\"creation_date\":1455572645,\"answer_id\":35419666,\"question_id\":28601663},{\"owner\":{\"reputation\":127749,\"user_id\":324584,\"user_type\":\"registered\",\"accept_rate\":93,\"profile_image\":\"https://i.stack.imgur.com/rPKTe.jpg?s=128&g=1\",\"display_name\":\"Mark Baker\",\"link\":\"http://stackoverflow.com/users/324584/mark-baker\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572643,\"creation_date\":1455572643,\"answer_id\":35419665,\"question_id\":35419607},{\"owner\":{\"reputation\":37,\"user_id\":1424856,\"user_type\":\"registered\",\"profile_image\":\"https://www.gravatar.com/avatar/7af1b0010a95769de8902b3f0e27102e?s=128&d=identicon&r=PG\",\"display_name\":\"DeaMon1\",\"link\":\"http://stackoverflow.com/users/1424856/deamon1\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572642,\"creation_date\":1455572642,\"answer_id\":35419664,\"question_id\":35418177},{\"owner\":{\"reputation\":692,\"user_id\":5268732,\"user_type\":\"registered\",\"profile_image\":\"https://i.stack.imgur.com/sdSZ5.jpg?s=128&g=1\",\"display_name\":\"Alessio Cantarella\",\"link\":\"http://stackoverflow.com/users/5268732/alessio-cantarella\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572640,\"creation_date\":1455572640,\"answer_id\":35419662,\"question_id\":35419555},{\"owner\":{\"reputation\":173030,\"user_id\":207421,\"user_type\":\"registered\",\"accept_rate\":82,\"profile_image\":\"https://www.gravatar.com/avatar/5cfe5f7d64f44be04f147295f5c7b88e?s=128&d=identicon&r=PG\",\"display_name\":\"EJP\",\"link\":\"http://stackoverflow.com/users/207421/ejp\"},\"is_accepted\":false,\"score\":1,\"last_activity_date\":1455572637,\"creation_date\":1455572637,\"answer_id\":35419661,\"question_id\":35419567},{\"owner\":{\"reputation\":354,\"user_id\":1980034,\"user_type\":\"registered\",\"profile_image\":\"https://www.gravatar.com/avatar/997b706f5854b7c79e1391d31664af3c?s=128&d=identicon&r=PG\",\"display_name\":\"faron\",\"link\":\"http://stackoverflow.com/users/1980034/faron\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572635,\"creation_date\":1455572635,\"answer_id\":35419659,\"question_id\":35393215},{\"owner\":{\"reputation\":1,\"user_id\":5928851,\"user_type\":\"registered\",\"profile_image\":\"https://lh6.googleusercontent.com/-a_EeSvRy6Lw/AAAAAAAAAAI/AAAAAAAAAHY/r1ovRIZxZqg/photo.jpg?sz=128\",\"display_name\":\"Константин Мезенцев\",\"link\":\"http://stackoverflow.com/users/5928851/%d0%9a%d0%be%d0%bd%d1%81%d1%82%d0%b0%d0%bd%d1%82%d0%b8%d0%bd-%d0%9c%d0%b5%d0%b7%d0%b5%d0%bd%d1%86%d0%b5%d0%b2\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572635,\"creation_date\":1455572635,\"answer_id\":35419658,\"question_id\":35418821},{\"owner\":{\"reputation\":10334,\"user_id\":2054072,\"user_type\":\"registered\",\"profile_image\":\"https://i.stack.imgur.com/VBy7X.jpg?s=128&g=1\",\"display_name\":\"Aper&#231;u\",\"link\":\"http://stackoverflow.com/users/2054072/aper%c3%a7u\"},\"is_accepted\":true,\"score\":6,\"last_activity_date\":1455572634,\"last_edit_date\":1455572634,\"creation_date\":1427194274,\"answer_id\":29230648,\"question_id\":29223471},{\"owner\":{\"reputation\":13,\"user_id\":1002170,\"user_type\":\"registered\",\"profile_image\":\"https://www.gravatar.com/avatar/f355b3857f92e4bb0a2430af6124cce8?s=128&d=identicon&r=PG\",\"display_name\":\"neuromusic\",\"link\":\"http://stackoverflow.com/users/1002170/neuromusic\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572633,\"creation_date\":1455572633,\"answer_id\":35419657,\"question_id\":35418989},{\"owner\":{\"reputation\":11,\"user_id\":4688403,\"user_type\":\"registered\",\"profile_image\":\"https://www.gravatar.com/avatar/6db1c1ed5e11a0e8ae0dcdc98ed7dbda?s=128&d=identicon&r=PG&f=1\",\"display_name\":\"Alex\",\"link\":\"http://stackoverflow.com/users/4688403/alex\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572633,\"last_edit_date\":1455572633,\"creation_date\":1455542221,\"answer_id\":35410390,\"question_id\":35409916},{\"owner\":{\"reputation\":19,\"user_id\":2676252,\"user_type\":\"registered\",\"profile_image\":\"https://i.stack.imgur.com/tkKIj.jpg?s=128&g=1\",\"display_name\":\"amir0220\",\"link\":\"http://stackoverflow.com/users/2676252/amir0220\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572632,\"creation_date\":1455572632,\"answer_id\":35419656,\"question_id\":35419379},{\"owner\":{\"reputation\":6290,\"user_id\":145080,\"user_type\":\"registered\",\"accept_rate\":100,\"profile_image\":\"https://www.gravatar.com/avatar/5bf96c68f651dbb13a7d1433f2a50e66?s=128&d=identicon&r=PG\",\"display_name\":\"Bryan Head\",\"link\":\"http://stackoverflow.com/users/145080/bryan-head\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572604,\"creation_date\":1455572604,\"answer_id\":35419653,\"question_id\":35414815},{\"owner\":{\"reputation\":295,\"user_id\":958809,\"user_type\":\"registered\",\"profile_image\":\"https://www.gravatar.com/avatar/ebde6bdc362d3b0c62831f6649f0dd76?s=128&d=identicon&r=PG\",\"display_name\":\"Doktorn\",\"link\":\"http://stackoverflow.com/users/958809/doktorn\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572601,\"creation_date\":1455572601,\"answer_id\":35419652,\"question_id\":34302958},{\"owner\":{\"reputation\":1336,\"user_id\":807126,\"user_type\":\"registered\",\"profile_image\":\"https://i.stack.imgur.com/C7jLB.jpg?s=128&g=1\",\"display_name\":\"Doug Stevenson\",\"link\":\"http://stackoverflow.com/users/807126/doug-stevenson\"},\"is_accepted\":false,\"score\":0,\"last_activity_date\":1455572597,\"creation_date\":1455572597,\"answer_id\":35419651,\"question_id\":35419531}],\"has_more\":true,\"quota_max\":300,\"quota_remaining\":269}"
end