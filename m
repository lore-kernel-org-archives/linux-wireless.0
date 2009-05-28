Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eta-ori.net ([91.121.142.51]:47399 "EHLO orion.eta-ori.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZE1QuY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 12:50:24 -0400
Received: from [10.0.0.10] (p4FEDFC70.dip.t-dialin.net [79.237.252.112])
	by orion.eta-ori.net (Postfix) with ESMTPSA id DE17C48C8A0
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2009 18:50:21 +0200 (CEST)
Message-ID: <4A1EC184.7040406@impulze.org>
Date: Thu, 28 May 2009 18:53:24 +0200
From: Daniel Mierswa <impulze@impulze.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: ath5k: works only occasionaly
References: <4A1EAEA7.4070208@impulze.org> <1243528150.20853.7.camel@mj>
In-Reply-To: <1243528150.20853.7.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28.05.2009 18:29, Pavel Roskin wrote:
> The current kernel version is more important than the one you tried
> initially.  Also, the chip revision from the kernel log may be useful.
Tried several stable releases from 2.6.24 to 2.6.29, current one is
2.6.30-rc6 tag from wireless-testing.git

> The reason for disconnect should be printed before that line.
I will log and save, once I'm at university again.

> It must be from the driver, not from wpa_supplicant.
Figured as much, otherwise it'd be very surprising if wpa_supplicant was
broken over a decade without anyone but me noticing. :)

> Using -Dwext or -Dnl80211 should have no effect on disconnects.
good to know, one thing less.

> If you can, try connecting to an access point with known good signal to
> see if the problem is caused by low signal.
Problem is that I don't have any "known working" APs in public. :-/

-- 
Mierswa, Daniel

If you still don't like it, that's ok: that's why I'm boss. I simply
know better than you do.
               --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22
