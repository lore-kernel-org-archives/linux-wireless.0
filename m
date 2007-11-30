Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2838 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932120AbXK3Afa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 19:35:30 -0500
Date: Fri, 30 Nov 2007 11:34:26 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>, dsd@gentoo.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: wireless vs. alignment requirements
Message-ID: <20071130003426.GJ23769@gondor.apana.org.au> (sfid-20071130_003533_611930_572E68AD)
References: <1195893216.4149.186.camel@johannes.berg> <20071124133200.GA27531@gondor.apana.org.au> <1195912176.4149.194.camel@johannes.berg> <20071124141319.GA27819@gondor.apana.org.au> <4748855C.5090103@linux-foundation.org> <474C50D7.5010901@zytor.com> <20071129131107.GC8487@gondor.apana.org.au> <474EFBEB.5000804@zytor.com> <20071130002621.GI23769@gondor.apana.org.au> <474F5932.1030103@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <474F5932.1030103@zytor.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 29, 2007 at 04:28:34PM -0800, H. Peter Anvin wrote:
>
> >sky2 is the exception here, not the rule.
> 
> It is, but it's not unique.  Several USB adapters have the same problem, 
> for example.

Notice the common theme here that slow (or slower, i.e., certainly nowhere
near 10Gb) NICs are the norm for violating alignment :)

So I'd prefer something that only penalised them rather than everybody
else.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
