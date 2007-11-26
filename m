Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4262 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757330AbXKZBhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 20:37:46 -0500
Date: Mon, 26 Nov 2007 09:36:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: dsd@gentoo.org, davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: wireless vs. alignment requirements
Message-ID: <20071126013655.GA22528@gondor.apana.org.au> (sfid-20071126_013748_617162_64B70971)
References: <20071124133200.GA27531@gondor.apana.org.au> <1195912176.4149.194.camel@johannes.berg> <20071124141319.GA27819@gondor.apana.org.au> <1195938799.4149.197.camel@johannes.berg> <20071125014446.GA32104@gondor.apana.org.au> <1195988428.4149.225.camel@johannes.berg> <20071125112251.GA10039@gondor.apana.org.au> <1195998864.4149.229.camel@johannes.berg> <20071125140121.GA12665@gondor.apana.org.au> <1196010257.4149.234.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196010257.4149.234.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 25, 2007 at 06:04:17PM +0100, Johannes Berg wrote:
>
> I'd think that totally depends on the traffic. If you have a non-QoS AP
> with WPS upstream connection, then the traffic to stations will be
> four-byte aligned while the WPS upstream will be at a 2-byte-mod-4
> boundary. And you'll have all packets from stations come in aligned and
> all response packets from wherever come in as WPS.

OK, sounds like you'll just have to fix them up after DMA.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
