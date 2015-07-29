Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56267 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbbG2JaT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 05:30:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Enrico Tagliavini <enrico.tagliavini@gmail.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: QCA6174 hw2.1 irq_mode=0 broken on 4.2-rc3, working on 4.1.2
References: <CAMQd7mbWC7rj8-eU7Jv21ehT8KrpC=L=xWxzDQxHEU_ePNSdUg@mail.gmail.com>
	<CA+BoTQmd0Uoi=2MNMsDXYe1yKsYa3P8uvVzWwXoMynQGtjeD4w@mail.gmail.com>
	<CAMQd7maioLviTaLHp+f03HafABijKD_d92K_SRO8XS51poKGqg@mail.gmail.com>
	<CA+BoTQkA0k1RBwzKFchcWebuWUmdoaqvaAq4BRz2o3C-GGUCog@mail.gmail.com>
	<CAMQd7ma7hehYLBf-5hUD0sViUwWGX8vy7ENXuBi8Q49F88A45Q@mail.gmail.com>
	<CA+BoTQkqttvPkk6qk6YV8SYPVnEcADfcUkLBCpjFoZBab81Byg@mail.gmail.com>
	<871tfr8ne9.fsf@kamboji.qca.qualcomm.com>
	<CAMQd7mY+upL+t9q0yJ0uL_jw_STEKL+hhe1PF_D5yPwfTkcgZg@mail.gmail.com>
Date: Wed, 29 Jul 2015 12:30:07 +0300
In-Reply-To: <CAMQd7mY+upL+t9q0yJ0uL_jw_STEKL+hhe1PF_D5yPwfTkcgZg@mail.gmail.com>
	(Enrico Tagliavini's message of "Wed, 29 Jul 2015 11:02:40 +0200")
Message-ID: <874mkn71ls.fsf@kamboji.qca.qualcomm.com> (sfid-20150729_113025_170723_97E4DEB2)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enrico Tagliavini <enrico.tagliavini@gmail.com> writes:

> Yeah that's what I meant. My idea was to first bisect only the ath10k
> directory, so restricting the bisect on the commits touching stuff
> there. I guess if the issue is more broad it will come up somewhere
> else as well, so this is a good starting point, I hope. Thank you for
> pointing it out though, this will actually be the first time I do a
> proper bisect.

And remember to always to mention if you have restricted the bisect
somehow, that's important information. And better if you provide 'git
bisect log' output as well.

> Also do you want me to bisect Kalle's sources or Linus' master? By
> what Michał said I guess Kalle's but I ask to be sure.
>
> Also to be clear: I'm using Linus' sources at the moment, as provided
> by Fedora rawhide.
>
> For me it's the same, so let me know what you prefer and is more
> useful to solve this issue.

Good that you brought this up. As ath.git master branch gets rebased
every rc1 release you really cannot use that for bisect. Either you
should use ath.git ath-next branch or Linus' tree. To be on the safe
side I always recommend to use Linus' tree if at all possible.

-- 
Kalle Valo
