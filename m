Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3607 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754134AbXK2NNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 08:13:18 -0500
Date: Fri, 30 Nov 2007 00:11:08 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>, dsd@gentoo.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: wireless vs. alignment requirements
Message-ID: <20071129131107.GC8487@gondor.apana.org.au> (sfid-20071129_131322_064986_90F5A911)
References: <E1IvoID-0006aR-00@gondolin.me.apana.org.au> <1195893216.4149.186.camel@johannes.berg> <20071124133200.GA27531@gondor.apana.org.au> <1195912176.4149.194.camel@johannes.berg> <20071124141319.GA27819@gondor.apana.org.au> <4748855C.5090103@linux-foundation.org> <474C50D7.5010901@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <474C50D7.5010901@zytor.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 27, 2007 at 09:16:07AM -0800, H. Peter Anvin wrote:
> 
> I wrote a patch for the IP stack to realign packets if necessary at one 
> point.  I should dredge it up again and submit it for collective flamage.

As long as it doesn't penalise Ethernet (e.g., the 10Gb crowd :) it would
be good to have.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
