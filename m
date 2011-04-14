Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41340 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502Ab1DNM4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 08:56:00 -0400
Received: by qwk3 with SMTP id 3so853610qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 05:56:00 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <BANLkTi=M+EfZqYqojkFxVnLWBgpHuEk4+w@mail.gmail.com>
References: <BANLkTimnQ92mgOzXMWXuF54tUs+M1ZbR1A@mail.gmail.com>
	<BANLkTin9KAQtYg0qWOPxw2HVq4MeXdhY3Q@mail.gmail.com>
	<BANLkTi=M+EfZqYqojkFxVnLWBgpHuEk4+w@mail.gmail.com>
Date: Thu, 14 Apr 2011 14:55:58 +0200
Message-ID: <BANLkTi=Ae8azoPghKCP_yQpsP0z+UqvM_A@mail.gmail.com>
Subject: Re: iwlagn / wpa_supplicant issue
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 14, 2011 at 2:34 PM, Fabio Coatti <fabio.coatti@gmail.com> wrote:
> 2011/4/14 Sedat Dilek <sedat.dilek@googlemail.com>:
>> Sorry for the top-post:
>>
>> Not sure if I have the same problem like you.
>> I was not lucky with the wpasupplicant (0.7.3-X) packaged in
>> Debian/sid, I downgraded to (0.6.10-2.1).
>>
>> IIRC last time I investigated the issue:
>> Replacing /etc/wpa_supplicant/functions.sh file from 0.7.x package
>> with the one from 0.6.x helped.
>> So... it could be a packaging problem?
>>
>> ( BTW, I am running systemd and resolvconf package and using a /e/n/i
>> with static-IPADDR setup, might be related to them, too. Busy with
>> other stuff and need a stable "working" Internet connection. And NO, I
>> did not write a bug-report. )
>
>
> Could you send to my mailbox  the two functions.sh scritps, so I can
> have a look if this can provide me any hint? Right now I've no debian
> available; I can check whatever changed and see what happens on my
> setup. It could be worth a try.
>
> Thanks.
>
>
>
>
> --
> Fabio
>

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=622757

- Sedat -
