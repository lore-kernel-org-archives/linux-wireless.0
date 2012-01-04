Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55188 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab2ADPE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 10:04:28 -0500
Received: by eekc4 with SMTP id c4so16727331eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2012 07:04:27 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
Date: Wed, 04 Jan 2012 16:04:18 +0100
Message-ID: <1408490.qSFZVkU7fA@helmutmobil.site> (sfid-20120104_160434_635385_ABDC5FE1)
In-Reply-To: <4F040FEA.3080703@01019freenet.de>
References: <4EFF12D9.3010602@01019freenet.de> <2766356.70ylY68Gqi@helmutmobil.site> <4F040FEA.3080703@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Am Mittwoch, 4. Januar 2012, 09:38:02 schrieb Andreas Hartmann:
> Helmut Schaa schrieb:
> >> Removing this patch
> >>
> >> mac80211: retry sending failed BAR frames later instead of tearing down
> >> aggr (http://www.spinics.net/lists/linux-wireless/msg76379.html) makes
> >> it working again.
> >>
> >> Device is: RaLink RT2800 802.11n PCI
> > 
> > What's the client device connected to the rt2x00 AP?
> 
> It's a rt3572 usb chip (Linksys WUSB600N v2), driven with the rt3572sta
> module.
> 
> > Mind to send a
> > 802.11 capture wen this stall happens?

Andreas provided me with a capture now. The interesting part is that
the rt2x00 AP sends bursts of BARs with the same sequence number when
the stall happens. I only had a quick look at the code in question but
couldn't see anything wrong at a first glance.

Helmut
