Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rain.florz.de ([62.216.164.86]:45070 "EHLO
	rain.florz.dyndns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755314AbZLSAiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 19:38:00 -0500
Date: Sat, 19 Dec 2009 01:37:47 +0100
From: Florian Zumbiehl <florz@florz.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: andreamrl@tiscali.it, herton@mandriva.com.br,
	htl10@users.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: Power consumption of RTL8187 (driver)/recommendations for
	low-power USB 802.11 adapter?
Message-ID: <20091219003746.GF2512@florz.florz.dyndns.org>
References: <20091218180205.GD2512@florz.florz.dyndns.org> <4B2BC7E3.2050907@lwfinger.net> <20091218185916.GE2512@florz.florz.dyndns.org> <4B2C100A.9000507@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B2C100A.9000507@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > For comparison, if I plug in and configure my prism2 card to connect
> > to the same AP, power consumption goes up by ~ 2 Watts while idling.
> > Given that it seems to be possible to build a wifi interface (plus driver)
> > that does manage to stay connected on a budget of ~ 2 Watts, I would hope
> > that there is such a thing for USB, too. b-only would be fine, too - it's
> > USB 1.1 only, anyhow.
> 
> I have no idea what the relative power consumption is for USB and PCI.
> Certainly, a PCI card can assume a cleaner power source - the USB is
> going to have to do heavier regulation.

Yeah - plus, the chip, according to realtek's website, wants 3.3 and
1.something V. If they are using a linear regulator for that - there must
be a reason for that low price, after all ... ;-)

> One other thing to try is to turn off the LED. Unset
> CONFIG_MAC80211_LEDS in your .config. That should save some power.

That's already off ...

Florian
