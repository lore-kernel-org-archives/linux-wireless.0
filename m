Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38512 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab0AKWhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 17:37:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: Ath5k on 2.6.32 suddenly fails
Date: Mon, 11 Jan 2010 23:36:49 +0100
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Bob Copeland <me@bobcopeland.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <201001101152.34316.mb@bu3sch.de> <43e72e891001110811u49ddb2d5qbc7bef3a7e3e76d1@mail.gmail.com>
In-Reply-To: <43e72e891001110811u49ddb2d5qbc7bef3a7e3e76d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001112336.50125.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 11 January 2010 17:11:10 Luis R. Rodriguez wrote:
> >  11 Jan 10 11:11:28 quimby kernel: [163143.871947] ath5k phy0: failed to wakeup the MAC Chip
> 
> So to be clear, this seems to be a regression from 2.6.31 to 2.6.32.
> Can you confirm if ath5k worked in AP mode smoothly without this issue
> or was this a regression against some random wireless-testing based
> snapshit (which seems to be the case).

I don't know if it is a regression between .31 and .32.
Before I upgraded to .32, I used a .31 kernel, but with compat-wireless.
So I did not use the .31 wireless bits (there were some other breakages
that I did not track down further)

I was either using
compat-wireless-2009-09-28
or
compat-wireless-2009-10-28

I don't really remember exactly which one. I don't really know how to
find out, though.
I was using it for months and it was rock-stable.

> Michael, it seems this is not easy to reproduce but can you try the
> latest 2.6.33-rc code to see if the issue is also there? I can make a
> new compat-wireless snapshot for that soon if it helps.

Well, It's a real pain to do experiments on that machine, because
it is a production machine. Each failure will immediately result in people
yelling at me. :D So I don't feel to well running an rc kernel on it...

I currently have one and a half days of uptime. I think I'll first
continue running .32 to check whether it happens again or if this was just
some random hardware burp.
I think it should be likely to trigger again within one or two days, if this is a bug.

-- 
Greetings, Michael.
