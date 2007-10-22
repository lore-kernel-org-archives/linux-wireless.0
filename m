Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46588 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbXJVV7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 17:59:54 -0400
Date: Tue, 23 Oct 2007 00:00:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Dan Williams <dcbw@redhat.com>,
	Luis Correia <luis.f.correia@gmail.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	mwallis@serialmonkey.com
Subject: Re: rt73usb: support for wireless in Kohjinsha subnotebook
Message-ID: <20071022220000.GH28190@elf.ucw.cz> (sfid-20071022_225958_828862_3B3496A7)
References: <20071020184100.GA11640@elf.ucw.cz> <20071022211325.GF28190@elf.ucw.cz> <200710222352.57543.IvDoorn@gmail.com> <200710221742.36693.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200710221742.36693.dhazelton@enter.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> > > Yes, I'm quite sure. There's MODULE_LICENCE("GPL"), IIRC.
> >
> > That doesn't say much, some manufacturers add that line to their driver
> >  just to prevent the module loader complaining about a non-GPL driver...
> >
> > There should be a copyright notice or a license file accompanied with
> > the driver that clearly states the license of the driver.
> 
> Lacking an explicitly stated license it can be argued that, since the 
> MODULE_LICENSE() macro is meant to define the actual license on the code, 
> this code is GPL. No, it isn't an explicit definition, but lacking any other 
> signs of the license, the implicit declaration of it being GPL is (or should 
> be) enough to deflect charges of copyright infringement.

Yep, I believe this driver is GPLed. They published the source and
there's nothing to suggest otherwise, and there's explicit:

#define DRIVER_AUTHOR                   "Jeff Lee<YY_Lee@issc.com.tw>"
#define DRIVER_DESC                             "IS89C35 802.11bg WLAN USB Driver"
MODULE_LICENSE("GPL");

 
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
