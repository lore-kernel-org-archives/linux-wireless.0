Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:53174 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbXLLKsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 05:48:52 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH RFT] b43: Fix for broken transmission
Date: Wed, 12 Dec 2007 11:46:48 +0100
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Joseph Jezak <josejx@gentoo.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Stefano Brivio <stefano.brivio@polimi.it>
References: <200712111343.50943.mb@bu3sch.de> <475F926C.2000003@lwfinger.net> <20071212032126.f62e3tx3c408ocgo@webmail.spamcop.net>
In-Reply-To: <20071212032126.f62e3tx3c408ocgo@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712121146.49198.mb@bu3sch.de> (sfid-20071212_104854_851860_31FCDF1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 December 2007 09:21:26 Pavel Roskin wrote:
> Quoting Larry Finger <larry.finger@lwfinger.net>:
> 
> > Michael Buesch wrote:
> >> Here's an updated version that should fix even more bugs:
> >> http://bu3sch.de/patches/wireless-2.6/20071211-1622/patches/005-b43-fix-init-rewrite-breakage.patch
> 
> I had to omit the last part (for tables.c) - it's unrelated, cosmetic  
> and doesn't apply to wireless-2.6/everything.

This patch depends on
[PATCH] b43: Fix ofdmtab write regression
And that is not just cosmetic.

> > This patch (and its predecessor) seem to make transmission at the   
> > OFDM rates a bit more reliable on
> > my BCM4311/2 card.
> 
> It's working fine on BCM4318 on PowerPC.  I haven't done any specific  
> comparisons, but it used to disconnect a lot (at least one an hour)  
> with a small antenna, so I installed a bigger antenna, but then gave  
> up and switched to using another wireless device (rtl8185).
> 
> Right now, it's been working for over 2 hours with a small antenna  
> (although it's a different antenna borrowed from rtl8185) and no  
> disconnects.  Scanning finds 5 APs, which is the most I have seen here.

Cool, thanks.

-- 
Greetings Michael.
