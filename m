Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:61864 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbXLGUrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 15:47:09 -0500
Received: by py-out-1112.google.com with SMTP id u77so1776457pyb
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2007 12:47:08 -0800 (PST)
Message-ID: <43e72e890712071247p78dcaf36p868d1dc002935417@mail.gmail.com> (sfid-20071207_204714_404685_5ABA90C0)
Date: Fri, 7 Dec 2007 15:47:07 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: lynx.abraxas@freenet.de
Subject: Re: What's wrong if wlan0 device is not reacting?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890712071225p774a2f9bg92540905dbd19e66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071206170858.GA2008@drago>
	 <8e6f94720712061052p105a9e82v290afb011765ba04@mail.gmail.com>
	 <20071206214807.GB1811@drago>
	 <43e72e890712061714i3427f558p9b94390955b0a817@mail.gmail.com>
	 <20071207201737.GA9192@drago>
	 <43e72e890712071225p774a2f9bg92540905dbd19e66@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 7, 2007 3:25 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

> > make
> > make -C /lib/modules/2.6.23.9/build M=/home/lynx/compat-wireless-2.6 modules
> > make[1]: Entering directory `/usr/src/linux-2.6.23.9'
> >   CC [M]  /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.o
> > In file included from /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:44:
> > /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/b43.h:783:3: error: #error "Using neither DMA nor PIO? Confused..."
> > /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c: In function 'b43_interrupt_tasklet':
> > /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:1451: error: implicit declaration of function 'b43_using_pio'
> > /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c: In function 'b43_one_core_attach':
> > /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:3857: error: 'modparam_pio' undeclared (first use in this function)
> > /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:3857: error: (Each undeclared identifier is reported only once
> > /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:3857: error: for each function it appears in.)
> > make[4]: *** [/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.o] Error 1
> > make[3]: *** [/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43] Error 2
> > make[2]: *** [/home/lynx/compat-wireless-2.6/drivers/net/wireless] Error 2
> > make[1]: *** [_module_/home/lynx/compat-wireless-2.6] Error 2
> > make[1]: Leaving directory `/usr/src/linux-2.6.23.9'
> > make: *** [modules] Error 2
>
> I just fixed this. I'll e-mail once I propagate the tarball.

OK give it a shot again, I just regenerated it.

http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2

  Luis
