Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59405 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752138AbYEGNFw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 09:05:52 -0400
Date: Wed, 7 May 2008 21:05:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH] mac80211: rewrite fragmentation code
Message-ID: <20080507130548.GA26977@gondor.apana.org.au> (sfid-20080507_150459_967740_4637A4F6)
References: <20080430124055.091382000@sipsolutions.net> <20080430130050.105344000@sipsolutions.net> <20080507071026.GA24407@gondor.apana.org.au> <1210150217.9305.39.camel@johannes.berg> <20080507090040.GA25186@gondor.apana.org.au> <1210159339.5642.13.camel@johannes.berg> <20080507114123.GA26073@gondor.apana.org.au> <1210161133.5642.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1210161133.5642.19.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 07, 2008 at 01:52:13PM +0200, Johannes Berg wrote:
>
> Hmm. Why does busy exist then? Historical accident? I really really

Yes it's historical baggage.  These days the biggest users would
be LLTX drivers which should all be converted to non-LLTX and
drivers that don't keep track of queue status properly.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
