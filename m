Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f211.google.com ([209.85.217.211]:59155 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZLRX2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 18:28:17 -0500
Received: by gxk3 with SMTP id 3so2529382gxk.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2009 15:28:16 -0800 (PST)
Message-ID: <4B2C100A.9000507@lwfinger.net>
Date: Fri, 18 Dec 2009 17:28:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Florian Zumbiehl <florz@florz.de>
CC: andreamrl@tiscali.it, herton@mandriva.com.br,
	htl10@users.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: Power consumption of RTL8187 (driver)/recommendations for	low-power
 USB 802.11 adapter?
References: <20091218180205.GD2512@florz.florz.dyndns.org> <4B2BC7E3.2050907@lwfinger.net> <20091218185916.GE2512@florz.florz.dyndns.org>
In-Reply-To: <20091218185916.GE2512@florz.florz.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/18/2009 12:59 PM, Florian Zumbiehl wrote:
> 
> Well, yeah, I meant "payload I care about", of course :-)
> 
> For comparison, if I plug in and configure my prism2 card to connect
> to the same AP, power consumption goes up by ~ 2 Watts while idling.
> Given that it seems to be possible to build a wifi interface (plus driver)
> that does manage to stay connected on a budget of ~ 2 Watts, I would hope
> that there is such a thing for USB, too. b-only would be fine, too - it's
> USB 1.1 only, anyhow.

I have no idea what the relative power consumption is for USB and PCI.
Certainly, a PCI card can assume a cleaner power source - the USB is
going to have to do heavier regulation.

One other thing to try is to turn off the LED. Unset
CONFIG_MAC80211_LEDS in your .config. That should save some power.
