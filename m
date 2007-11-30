Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:36175 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbXK3Ali (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 19:41:38 -0500
Message-ID: <474F5C2B.8040300@zytor.com> (sfid-20071130_004143_012129_0DE5AB2D)
Date: Thu, 29 Nov 2007 16:41:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>, dsd@gentoo.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: wireless vs. alignment requirements
References: <1195893216.4149.186.camel@johannes.berg> <20071124133200.GA27531@gondor.apana.org.au> <1195912176.4149.194.camel@johannes.berg> <20071124141319.GA27819@gondor.apana.org.au> <4748855C.5090103@linux-foundation.org> <474C50D7.5010901@zytor.com> <20071129131107.GC8487@gondor.apana.org.au> <474EFBEB.5000804@zytor.com> <20071130002621.GI23769@gondor.apana.org.au> <474F5932.1030103@zytor.com> <20071130003426.GJ23769@gondor.apana.org.au>
In-Reply-To: <20071130003426.GJ23769@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herbert Xu wrote:
> On Thu, Nov 29, 2007 at 04:28:34PM -0800, H. Peter Anvin wrote:
>>> sky2 is the exception here, not the rule.
>> It is, but it's not unique.  Several USB adapters have the same problem, 
>> for example.
> 
> Notice the common theme here that slow (or slower, i.e., certainly nowhere
> near 10Gb) NICs are the norm for violating alignment :)
> 
> So I'd prefer something that only penalised them rather than everybody
> else.

Obviously, and this should be a configure option anyway.

	-hpa
