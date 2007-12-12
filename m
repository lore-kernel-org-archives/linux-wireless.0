Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:53563 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264AbXLLIV2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 03:21:28 -0500
Message-ID: <20071212032126.f62e3tx3c408ocgo@webmail.spamcop.net> (sfid-20071212_082137_270608_6109C2F7)
Date: Wed, 12 Dec 2007 03:21:26 -0500
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, Joseph Jezak <josejx@gentoo.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH RFT] b43: Fix for broken transmission
References: <200712111343.50943.mb@bu3sch.de>
	<200712111622.54086.mb@bu3sch.de> <475F926C.2000003@lwfinger.net>
In-Reply-To: <475F926C.2000003@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Larry Finger <larry.finger@lwfinger.net>:

> Michael Buesch wrote:
>> Here's an updated version that should fix even more bugs:
>> http://bu3sch.de/patches/wireless-2.6/20071211-1622/patches/005-b43-fix-init-rewrite-breakage.patch

I had to omit the last part (for tables.c) - it's unrelated, cosmetic  
and doesn't apply to wireless-2.6/everything.

> This patch (and its predecessor) seem to make transmission at the   
> OFDM rates a bit more reliable on
> my BCM4311/2 card.

It's working fine on BCM4318 on PowerPC.  I haven't done any specific  
comparisons, but it used to disconnect a lot (at least one an hour)  
with a small antenna, so I installed a bigger antenna, but then gave  
up and switched to using another wireless device (rtl8185).

Right now, it's been working for over 2 hours with a small antenna  
(although it's a different antenna borrowed from rtl8185) and no  
disconnects.  Scanning finds 5 APs, which is the most I have seen here.

-- 
Regards,
Pavel Roskin
