Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [78.193.33.39] ([78.193.33.39]:45693 "EHLO qult.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933869Ab3FSSEC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 14:04:02 -0400
Date: Wed, 19 Jun 2013 20:03:54 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Oleksij Rempel <linux@rempel-privat.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Corey Richardson <corey@octayn.net>
Subject: Re: [ath9k-devel] ath9k_htc: station unable to authenticate
Message-ID: <20130619180354.GB19405@zenon.in.qult.net> (sfid-20130619_200406_586598_E6986375)
References: <20130619115809.GA26717@zenon.in.qult.net>
 <51C1ACEC.2020703@rempel-privat.de>
 <1DC40B07CD6EC041A66726C271A73AE61AA312F5@IRSMSX102.ger.corp.intel.com>
 <51C1B467.1030509@rempel-privat.de>
 <20130619140905.GA14079@zenon.in.qult.net>
 <1371651073.8349.19.camel@jlt4.sipsolutions.net>
 <51C1C95C.8030301@rempel-privat.de>
 <20130619175939.GA19405@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130619175939.GA19405@zenon.in.qult.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 19, 2013 at 07:59:39PM +0200, thus spake Ignacy Gawedzki:
> On Wed, Jun 19, 2013 at 05:08:12PM +0200, thus spake Oleksij Rempel:
> > Ignacy, Is it RPi +  TL-WN722NC?
> 
> Yes, absolutely, but it happens on a Dell XPS 13" as well (Ubuntu 13.04).

BTW, removing CFG80211_DEFAULT_PS doesn't make any difference.

-- 
Everything is more fun naked except cooking with grease.
