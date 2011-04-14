Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:56764 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab1DNMjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 08:39:35 -0400
Received: by pxi2 with SMTP id 2so889555pxi.10
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 05:39:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTin9KAQtYg0qWOPxw2HVq4MeXdhY3Q@mail.gmail.com>
References: <BANLkTimnQ92mgOzXMWXuF54tUs+M1ZbR1A@mail.gmail.com>
	<BANLkTin9KAQtYg0qWOPxw2HVq4MeXdhY3Q@mail.gmail.com>
Date: Thu, 14 Apr 2011 14:34:27 +0200
Message-ID: <BANLkTi=M+EfZqYqojkFxVnLWBgpHuEk4+w@mail.gmail.com>
Subject: Re: iwlagn / wpa_supplicant issue
From: Fabio Coatti <fabio.coatti@gmail.com>
To: sedat.dilek@gmail.com
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/14 Sedat Dilek <sedat.dilek@googlemail.com>:
> Sorry for the top-post:
>
> Not sure if I have the same problem like you.
> I was not lucky with the wpasupplicant (0.7.3-X) packaged in
> Debian/sid, I downgraded to (0.6.10-2.1).
>
> IIRC last time I investigated the issue:
> Replacing /etc/wpa_supplicant/functions.sh file from 0.7.x package
> with the one from 0.6.x helped.
> So... it could be a packaging problem?
>
> ( BTW, I am running systemd and resolvconf package and using a /e/n/i
> with static-IPADDR setup, might be related to them, too. Busy with
> other stuff and need a stable "working" Internet connection. And NO, I
> did not write a bug-report. )


Could you send to my mailbox  the two functions.sh scritps, so I can
have a look if this can provide me any hint? Right now I've no debian
available; I can check whatever changed and see what happens on my
setup. It could be worth a try.

Thanks.




-- 
Fabio
