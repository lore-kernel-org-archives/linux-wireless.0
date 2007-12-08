Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:45752 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbXLHHoG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 02:44:06 -0500
Received: from [195.4.92.13] (helo=3.mx.freenet.de)
	by mout0.freenet.de with esmtpa (Exim 4.68)
	(envelope-from <lynx.abraxas@freenet.de>)
	id 1J0uLz-0005jb-IE
	for linux-wireless@vger.kernel.org; Sat, 08 Dec 2007 08:44:03 +0100
Received: from p508e40ce.dip.t-dialin.net ([80.142.64.206]:58296 helo=localhost)
	by 3.mx.freenet.de with esmtpsa (ID lynx.abraxas@freenet.de) (TLSv1:AES256-SHA:256) (port 587) (Exim 4.68 #1)
	id 1J0uLz-0003qj-9N
	for linux-wireless@vger.kernel.org; Sat, 08 Dec 2007 08:44:03 +0100
Date: Sat, 8 Dec 2007 08:44:02 +0100
From: lynx.abraxas@freenet.de
To: linux-wireless@vger.kernel.org
Subject: Re: What's wrong if wlan0 device is not reacting?
Message-ID: <20071208074402.GA2508@drago> (sfid-20071208_074409_550016_54D5C6D0)
References: <20071206170858.GA2008@drago> <8e6f94720712061052p105a9e82v290afb011765ba04@mail.gmail.com> <20071206214807.GB1811@drago> <43e72e890712061714i3427f558p9b94390955b0a817@mail.gmail.com> <8e6f94720712071121n234d9d23idaaf49d76b2fe227@mail.gmail.com> <43e72e890712071336v2a4a805eu6aff9ff9c10c9418@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890712071336v2a4a805eu6aff9ff9c10c9418@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Checked  this  morning  but I'm still getting errors there. Could I be missing
some configuration of the build?


  CC [M]  /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.o
In file included from /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:44:
/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/b43.h:783:3: error: #error "Using neither DMA nor PIO? Confused..."
/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c: In function 'b43_interrupt_tasklet':
/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:1451: error: implicit declaration of function 'b43_using_pio'
/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c: In function 'b43_one_core_attach':
/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:3857: error: 'modparam_pio' undeclared (first use in this function)
/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:3857: error: (Each undeclared identifier is reported only once
/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:3857: error: for each function it appears in.)
make[4]: *** [/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.o] Error 1
make[3]: *** [/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43] Error 2
make[2]: *** [/home/lynx/compat-wireless-2.6/drivers/net/wireless] Error 2
make[1]: *** [_module_/home/lynx/compat-wireless-2.6] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.23.9'
make: *** [modules] Error 2


I'll  be  off  my  parents  house till the next year. I'll be able to test the
compilation but not the function with the device  till  January.  I'll  reprot
back then.


Thanks  very much for the help so far. Would be great to get the thing running
some time.

Lynx
