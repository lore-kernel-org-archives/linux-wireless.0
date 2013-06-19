Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [78.193.33.39] ([78.193.33.39]:44994 "EHLO qult.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933833Ab3FSOJN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 10:09:13 -0400
Date: Wed, 19 Jun 2013 16:09:06 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: "Berg, Johannes" <johannes.berg@intel.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k_htc: station unable to authenticate
Message-ID: <20130619140905.GA14079@zenon.in.qult.net> (sfid-20130619_160921_593309_5728C3A1)
References: <20130619115809.GA26717@zenon.in.qult.net>
 <51C1ACEC.2020703@rempel-privat.de>
 <1DC40B07CD6EC041A66726C271A73AE61AA312F5@IRSMSX102.ger.corp.intel.com>
 <51C1B467.1030509@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51C1B467.1030509@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 19, 2013 at 03:38:47PM +0200, thus spake Oleksij Rempel:
> hm.. looks like this code depends on power_save. is it correct?
> 
> Ignacy,
> 
> can you please take a look if power_save mode is enabled by you.
> 
> iw dev wlan0 get power_save
> 
> if yes. Try to disable it.

Although I have been building with CFG80211_DEFAULT_PS=y, the iw get
power_save command tells me it's off.

> I think last week power_save was set to disabled by default. There
> are too many bugs right now.

I'll test without CFG80211_DEFAULT_PS, just to be sure.

Thanks for the hint.

-- 
NO CARRIER
