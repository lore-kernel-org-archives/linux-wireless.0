Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:35802 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbXK3A3C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 19:29:02 -0500
Message-ID: <474F5932.1030103@zytor.com> (sfid-20071130_002908_623555_6EDE06F5)
Date: Thu, 29 Nov 2007 16:28:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>, dsd@gentoo.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: wireless vs. alignment requirements
References: <E1IvoID-0006aR-00@gondolin.me.apana.org.au> <1195893216.4149.186.camel@johannes.berg> <20071124133200.GA27531@gondor.apana.org.au> <1195912176.4149.194.camel@johannes.berg> <20071124141319.GA27819@gondor.apana.org.au> <4748855C.5090103@linux-foundation.org> <474C50D7.5010901@zytor.com> <20071129131107.GC8487@gondor.apana.org.au> <474EFBEB.5000804@zytor.com> <20071130002621.GI23769@gondor.apana.org.au>
In-Reply-To: <20071130002621.GI23769@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herbert Xu wrote:
> On Thu, Nov 29, 2007 at 09:50:35AM -0800, H. Peter Anvin wrote:
>> Uhm, most cards affected *ARE* Ethernet cards, due to the bloody 14-byte 
>> header.
> 
> Well most Ethernet drivers are using NET_IP_ALIGN which means that IP
> stack gets aligned packets only.
> 
> sky2 is the exception here, not the rule.
> 

It is, but it's not unique.  Several USB adapters have the same problem, 
for example.

	-hpa
