Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38081 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbbG2F2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 01:28:21 -0400
Received: by wibxm9 with SMTP id xm9so9797964wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2015 22:28:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMQd7ma7hehYLBf-5hUD0sViUwWGX8vy7ENXuBi8Q49F88A45Q@mail.gmail.com>
References: <CAMQd7mbWC7rj8-eU7Jv21ehT8KrpC=L=xWxzDQxHEU_ePNSdUg@mail.gmail.com>
	<CA+BoTQmd0Uoi=2MNMsDXYe1yKsYa3P8uvVzWwXoMynQGtjeD4w@mail.gmail.com>
	<CAMQd7maioLviTaLHp+f03HafABijKD_d92K_SRO8XS51poKGqg@mail.gmail.com>
	<CA+BoTQkA0k1RBwzKFchcWebuWUmdoaqvaAq4BRz2o3C-GGUCog@mail.gmail.com>
	<CAMQd7ma7hehYLBf-5hUD0sViUwWGX8vy7ENXuBi8Q49F88A45Q@mail.gmail.com>
Date: Wed, 29 Jul 2015 07:28:19 +0200
Message-ID: <CA+BoTQkqttvPkk6qk6YV8SYPVnEcADfcUkLBCpjFoZBab81Byg@mail.gmail.com> (sfid-20150729_072824_890391_2DB84066)
Subject: Re: QCA6174 hw2.1 irq_mode=0 broken on 4.2-rc3, working on 4.1.2
From: Michal Kazior <michal.kazior@tieto.com>
To: Enrico Tagliavini <enrico.tagliavini@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 July 2015 at 16:57, Enrico Tagliavini <enrico.tagliavini@gmail.com> wrote:
> I was testing the kernel from Fedora rawhide to test some issue
> related to the sound card. So this is 4.2 rc3 as released by Linus
> plus some Fedora patch. Nothing related to ath10k as far as I can see.
>
> Bisecting would require a lot of time. I'm doing the full RPM package,
> including modules signature and so on and I'm doing this in my free
> time.

I understand.


> This wont work for bisecting. I have to setup something else. Is
> it ok if I restrict the bisect on the ath10k tree? That has enough
> commit already to begin with, plus I'm going to be on the road in less
> than two weeks.

As long as you establish a working and a non-working commit id on
kvalo tree it should be fine I guess.


Michał
