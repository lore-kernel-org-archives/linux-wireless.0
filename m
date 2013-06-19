Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [78.193.33.39] ([78.193.33.39]:45980 "EHLO qult.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934566Ab3FSTgd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 15:36:33 -0400
Date: Wed, 19 Jun 2013 21:36:24 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Ben Greear <greearb@candelatech.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Corey Richardson <corey@octayn.net>
Subject: Re: [ath9k-devel] ath9k_htc: station unable to authenticate
Message-ID: <20130619193624.GB29582@zenon.in.qult.net> (sfid-20130619_213637_665987_CF0EFD8E)
References: <51C1ACEC.2020703@rempel-privat.de>
 <1DC40B07CD6EC041A66726C271A73AE61AA312F5@IRSMSX102.ger.corp.intel.com>
 <51C1B467.1030509@rempel-privat.de>
 <20130619140905.GA14079@zenon.in.qult.net>
 <1371651073.8349.19.camel@jlt4.sipsolutions.net>
 <51C1C95C.8030301@rempel-privat.de>
 <20130619175939.GA19405@zenon.in.qult.net>
 <20130619180354.GB19405@zenon.in.qult.net>
 <51C1FA76.3090109@rempel-privat.de>
 <51C1FAFB.9090209@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51C1FAFB.9090209@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 19, 2013 at 11:39:55AM -0700, thus spake Ben Greear:
> Does the ath9k_htc do it's own rate control, perhaps modelled on
> ath9k_rate_control algorithm?

Do you mean ATH9K_LEGACY_RATE_CONTROL ?

> If so, that could be the problem...it has issues with associating when
> network conditions are poor...

Frankly, I doubt this is the case.  With so many different setups, and the AP
is like one meter away from the station right now.

-- 
The groove will take you through times without money
much better than money will take you through times without groove.
