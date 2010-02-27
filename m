Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37120 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968441Ab0B0Ova convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 09:51:30 -0500
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH 01/11] b43: N-PHY: add some registers and structs  definitions
Date: Sat, 27 Feb 2010 15:51:25 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com> <201002100002.11369.mb@bu3sch.de> <b170af451002270312y304b9c81mc6223a6e28608f3a@mail.gmail.com>
In-Reply-To: <b170af451002270312y304b9c81mc6223a6e28608f3a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201002271551.26126.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 27 February 2010 12:12:23 Rafał Miłecki wrote:
> 2010/2/10 Michael Buesch <mb@bu3sch.de>:
> > On Tuesday 09 February 2010 21:04:33 Rafał Miłecki wrote:
> >> +#define B43_MMIO_PSM_PHY_HDR         0x492   /* programmable state machine */
> >
> > The comment doesn't make a lot of sense.
> > In case you don't know, the PSM is the part of the hardware
> > that executes the firmware.
> 
> Well, guess you're right. It was me hearing for the first time "PSM"
> so decided to write it. Guess it's pretty obvious for every device
> driver developer :)
> 

Well, what I wanted to say is that it's more important to explain
what PHY_HDR means. Something like /* PSM PHY header */ ?

-- 
Greetings, Michael.
