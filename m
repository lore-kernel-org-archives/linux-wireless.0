Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40613
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261AbXJMPXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 11:23:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Subject: Re: b43: regression on bcm4318
Date: Sat, 13 Oct 2007 17:22:32 +0200
Cc: bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@redhat.com>,
	linux-wireless@vger.kernel.org
References: <20071013121730.1eef0d93@kernel.crashing.org> <200710131024.48113.mb@bu3sch.de> <20071013181431.13bf50a3@kernel.crashing.org>
In-Reply-To: <20071013181431.13bf50a3@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710131722.32949.mb@bu3sch.de> (sfid-20071013_162317_426603_95B4C9C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 13 October 2007 16:14:31 Vitaly Bordug wrote:
> Hello Michael,
> 
> On Sat, 13 Oct 2007 10:24:47 +0200
> Michael Buesch wrote:
> 
> > On Saturday 13 October 2007 10:17:30 Vitaly Bordug wrote:
> > > phy1: Failed to select rate control algorithm
> > > phy1: Failed to initialize rate control algorithm
> > 
> > That's nothing b43 or ssb related.
> > Compile and load the rc80211_simple module.
> > 
> oh, thanks, that was broken module dependencies. Well at least it is saved in archive now, no nobody else
> would step into it.
> 
> Another question: is this driver known to work okay in ad-hoc or master mode? I gave it a try and there is no
> driver-side whine, but it does not seem to work either. I see couple of packages turnaround, sometimes even
> dhcp server is able to feed IP via wlan (host is acting as kinda AP), but nothing after that.

Master and adhoc is not stable, yet.
It might work, though. But I didn't really test that recently.

-- 
Greetings Michael.
