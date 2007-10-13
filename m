Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:44866 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbXJMOOz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 10:14:55 -0400
Date: Sat, 13 Oct 2007 18:14:31 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: b43: regression on bcm4318
Message-ID: <20071013181431.13bf50a3@kernel.crashing.org> (sfid-20071013_151459_365523_50FF43F1)
In-Reply-To: <200710131024.48113.mb@bu3sch.de>
References: <20071013121730.1eef0d93@kernel.crashing.org>
	<200710131024.48113.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Michael,

On Sat, 13 Oct 2007 10:24:47 +0200
Michael Buesch wrote:

> On Saturday 13 October 2007 10:17:30 Vitaly Bordug wrote:
> > phy1: Failed to select rate control algorithm
> > phy1: Failed to initialize rate control algorithm
> 
> That's nothing b43 or ssb related.
> Compile and load the rc80211_simple module.
> 
oh, thanks, that was broken module dependencies. Well at least it is saved in archive now, no nobody else
would step into it.

Another question: is this driver known to work okay in ad-hoc or master mode? I gave it a try and there is no
driver-side whine, but it does not seem to work either. I see couple of packages turnaround, sometimes even
dhcp server is able to feed IP via wlan (host is acting as kinda AP), but nothing after that.

And, soon after actual b43 replaced bcm... in rawhide, the same worked, e.g. for at least 5 minutes my wifi-enabled
E61 was able stay up and connected (b43 was in ad-hoc mode that time).

I would appreciate any feedback.
TIA

-- 
Sincerely, Vitaly
