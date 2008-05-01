Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52908 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754825AbYEALDy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 07:03:54 -0400
Date: Thu, 1 May 2008 19:03:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: mac80211 truesize bugs
Message-ID: <20080501110341.GD7490@gondor.apana.org.au> (sfid-20080501_130340_686681_C9F2BD03)
References: <20080501.024320.212547875.davem@davemloft.net> <E1JrW9h-0001tI-00@gondolin.me.apana.org.au> <20080501.034950.261408566.davem@davemloft.net> <20080501.035335.216935614.davem@davemloft.net> <1209639500.7067.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1209639500.7067.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 01, 2008 at 12:58:20PM +0200, Johannes Berg wrote:
>
> Indeed. But then why did we never see this bug w/o monitor interfaces
> and this reinjection?

The debugging only catches it if the expanded area actually
gets used, e.g., by skb_push.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
