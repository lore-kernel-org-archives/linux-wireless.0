Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51107 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137Ab0AOWah (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 17:30:37 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: Ath5k on 2.6.32 suddenly fails
Date: Fri, 15 Jan 2010 23:29:59 +0100
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Bob Copeland <me@bobcopeland.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <201001101152.34316.mb@bu3sch.de> <43e72e891001110811u49ddb2d5qbc7bef3a7e3e76d1@mail.gmail.com> <201001112336.50125.mb@bu3sch.de>
In-Reply-To: <201001112336.50125.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001152330.00470.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 11 January 2010 23:36:49 Michael Buesch wrote:
> I currently have one and a half days of uptime. I think I'll first
> continue running .32 to check whether it happens again or if this was just
> some random hardware burp.
> I think it should be likely to trigger again within one or two days, if this is a bug.

mb@quimby:~$ uptime
 23:23:34 up 5 days, 11:49,  1 user,  load average: 0.00, 0.00, 0.00

So, it didn't trigger, yet.
I think I will assume for now that we had a hardware burp and this
is not caused by a software bug. The AP is used a lot and it currently
is rock-stable on 2.6.32.

The card is a minipci connected through a minipci->pci converter card.
I know that the converter does not have high quality contact pins, so I
currently blame the converter card for flipping a bit.
I think I'll replace it by something better soon.

So let's close this, unless I come back to you guys with new results.

-- 
Greetings, Michael.
