Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42325 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759318AbXHCKlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 06:41:10 -0400
Subject: Re: mac80211 IPv6 problems
From: David Woodhouse <dwmw2@infradead.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: flamingice@sourmilk.net, linux-wireless@vger.kernel.org,
	jbenc@suse.cz, Michael Buesch <mb@bu3sch.de>,
	Daniel Drake <dsd@gentoo.org>, Bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
In-Reply-To: <20070803005517.GA4261@tuxdriver.com>
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net>
	 <200708021807.20649.mb@bu3sch.de> <46B20695.2080100@lwfinger.net>
	 <1186088678.2931.10.camel@pmac.infradead.org> <46B25B04.5020804@gentoo.org>
	 <1186094778.6701.6.camel@shinybook.infradead.org>
	 <20070803005517.GA4261@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 03 Aug 2007 11:40:57 +0100
Message-Id: <1186137657.2931.45.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-08-02 at 20:55 -0400, John W. Linville wrote:
> I hacked-up the (untested) patch below -- thoughts? 

I tried to test it. Today, I get no connectivity with bcm43xx-mac80211
(from Fedora 7 + your patch).

It does manage to associate, but tcpdump shows it doesn't seem to
receive any packets correctly -- http://david.woodhou.se/bcm43xx-bad.txt

I tried taking the device down and back up, and setting the WEP key
again (I think I've seen it screw up before and have to be told the WEP
key again before it starts working), but that didn't help. Removing the
module left rmmod and ksoftirqd both eating CPU, so I had to reboot.

I don't have time to do any more right now; I might look at it again in
a couple of weeks when I get home. But all this ought to be
reproduceable elsewhere -- and if it isn't, I have a Cardbus card which
seems to be exactly the same rev 4306 as my shinybook's internal device.
Give me an address to ship it to :)

-- 
dwmw2

