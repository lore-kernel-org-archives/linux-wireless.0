Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47390 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754066AbYEDJo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 05:44:58 -0400
Date: Sun, 4 May 2008 17:44:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: mac80211 truesize bugs
Message-ID: <20080504094444.GA541@gondor.apana.org.au> (sfid-20080504_114425_247548_E3272549)
References: <1209815533.3987.21.camel@johannes.berg> <20080503.180300.10562559.davem@davemloft.net> <1209865354.6210.23.camel@johannes.berg> <20080504020203.GA30514@gondor.apana.org.au> <1209866916.6210.39.camel@johannes.berg> <20080504021213.GA30660@gondor.apana.org.au> <1209867740.6210.46.camel@johannes.berg> <20080504031652.GA30993@gondor.apana.org.au> <1209890847.6210.51.camel@johannes.berg> <1209892489.6210.56.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1209892489.6210.56.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 04, 2008 at 11:14:49AM +0200, Johannes Berg wrote:
>
> I just re-did the test, and I definitely need 29 more bytes on, for
> example, the IPv6 autodiscovery packets and ICMP packets generated with
> ping(8). Some of them even need additional tailroom.

Could you find out the code path that created the skb in the
kernel so we can see why there isn't enough head room?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
