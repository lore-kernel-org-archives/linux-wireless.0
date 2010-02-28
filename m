Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39302 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab0B1LqY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 06:46:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH 01/11] b43: N-PHY: add some registers and structs  definitions
Date: Sun, 28 Feb 2010 12:46:15 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com> <201002271551.26126.mb@bu3sch.de> <b170af451002271737l955b819n582b9dd4c12ab747@mail.gmail.com>
In-Reply-To: <b170af451002271737l955b819n582b9dd4c12ab747@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201002281246.15965.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 February 2010 02:37:21 Rafał Miłecki wrote:
> W dniu 27 lutego 2010 15:51 użytkownik Michael Buesch <mb@bu3sch.de> napisał:
> > On Saturday 27 February 2010 12:12:23 Rafał Miłecki wrote:
> >> 2010/2/10 Michael Buesch <mb@bu3sch.de>:
> >> > On Tuesday 09 February 2010 21:04:33 Rafał Miłecki wrote:
> >> >> +#define B43_MMIO_PSM_PHY_HDR         0x492   /* programmable state machine */
> >> >
> >> > The comment doesn't make a lot of sense.
> >> > In case you don't know, the PSM is the part of the hardware
> >> > that executes the firmware.
> >>
> >> Well, guess you're right. It was me hearing for the first time "PSM"
> >> so decided to write it. Guess it's pretty obvious for every device
> >> driver developer :)
> >>
> >
> > Well, what I wanted to say is that it's more important to explain
> > what PHY_HDR means. Something like /* PSM PHY header */ ?
> 
> Sure, explaining HDR sounds great, but do you actually know it's
> header? Personally I have no idea, so I am not sure if you know that
> with nice probability of being right, or are you just guessing? :)

Well, I assumed you could deduce the meaning from the code. If not, it's
better to leave it without a comment. I don't know for sure what this means.
But declaring the definition as "Programmable State Machine" is also
wrong. So let's simply leave it without a comment.


-- 
Greetings, Michael.
