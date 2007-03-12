Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:35028 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbXCLRmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 13:42:31 -0400
Message-ID: <45F590FA.4020409@lwfinger.net>
Date: Mon, 12 Mar 2007 12:42:18 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Joseph Jezak <josejx@gentoo.org>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] bcm43xx: Fix typo in B5PHY init specifications
References: <45e85f2b.Dp1dM05tvZFFROmc%Larry.Finger@lwfinger.net>	<1173685989.3584.2.camel@shinybook.infradead.org>	<45F55452.3000704@gentoo.org>  <20070312145309.GB8878@tuxdriver.com> <1173712594.3584.6.camel@shinybook.infradead.org>
In-Reply-To: <1173712594.3584.6.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse wrote:
> On Mon, 2007-03-12 at 10:53 -0400, John W. Linville wrote:
>> FWIW, by inspection it looks like the mac80211-based driver is
>> (trying?) to implement this change.
>>
>> David, have you tried the mac80211 version?  Does it still have the
>> same crash?
> 
> Should the one in 2.6.20-1.2982.fc7 be OK? I can try that relatively
> easily; anything else might need to wait till I get home.
> 

I don't think it will improve anything. I don't currently have a copy of wireless-dev, but the code
in the mb tree is identical with that of wireless-2.6. I'm currently trying to figure out the spec
at http://bcm-v4.sipsolutions.net/802.11/PHY/calinit and what we need to change.

Larry
