Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40691 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbcDJLwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2016 07:52:00 -0400
Date: Sun, 10 Apr 2016 13:51:41 +0200
From: Pavel Machek <pavel@denx.de>
To: "Machani, Yaniv" <yanivma@ti.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Luciano Coelho <coelho@ti.com>, "Balbi, Felipe" <balbi@ti.com>,
	"Chalmers, Kevin" <kev@ti.com>, Shahar Levi <shahar_levi@ti.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"Davis, Andrew" <afd@ti.com>, "Mishol, Guy" <guym@ti.com>,
	Arik Nemtsov <arik@wizery.com>, Gery Kahn <geryk@ti.com>,
	Felipe Balbi <balbi@kernel.org>,
	Luciano Coelho <luca@coelho.fi>,
	David Woodhouse <dwmw2@infradead.org>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Ben Hutchings <ben@decadent.org.uk>,
	David Gnedt <david.gnedt@platinumzone24.at>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sebastian Reichel <sre@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Menon, Nishanth" <nm@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: AP firmware for TI wl1251 wifi chip (wl1251-fw-ap.bin)
Message-ID: <20160410115141.GD30188@xo-6d-61-c0.localdomain> (sfid-20160410_135246_918410_09B81539)
References: <201603200040.26045@pali>
 <20160404123944.GA8413@pali>
 <AE1C82FB3D0EC64DB1F752C81CBD1101390F6305@DFRE01.ent.ti.com>
 <201604061412.43684@pali>
 <AE1C82FB3D0EC64DB1F752C81CBD1101390F685E@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AE1C82FB3D0EC64DB1F752C81CBD1101390F685E@DFRE01.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> > > wl1251 does not support AP mode, so there is no firmware for it in 
> > > the tree.
> > >
> > > Regards,
> > > Yaniv
> > 
> > Hi Yaniv! I read on some TI whitepaper, that wl1251 hardware supports 
> > some Soft-AP mode. So I expect that either special FW is needed for it 
> > or somehow it is possible to use current released. Do you have any information about it?
> 
> Hi Pali,
> This must be some typo, the device does not support Soft-AP.
> More than that, wl1251 family is not officially supported via the mainline Linux.


> For Soft-AP, and other new features based on Linux you should use WiLink8 chip family.

Too late for that, we already have the devices, and they were manufactured quite long
time ago.

Is it "hardware can't do AP", "firmware can't do AP" or "current drivers 
do not support AP"?

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
