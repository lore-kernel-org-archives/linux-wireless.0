Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:48651 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbXK1Cz1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 21:55:27 -0500
Message-ID: <474CD592.2020108@zytor.com> (sfid-20071128_025532_297962_520ED368)
Date: Tue, 27 Nov 2007 18:42:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
	Johannes Berg <johannes@sipsolutions.net>, dsd@gentoo.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: wireless vs. alignment requirements
References: <E1IvoID-0006aR-00@gondolin.me.apana.org.au>	<1195893216.4149.186.camel@johannes.berg>	<20071124133200.GA27531@gondor.apana.org.au>	<1195912176.4149.194.camel@johannes.berg>	<20071124141319.GA27819@gondor.apana.org.au>	<4748855C.5090103@linux-foundation.org>	<474C50D7.5010901@zytor.com> <20071127103940.314c7844@freepuppy.rosehill>
In-Reply-To: <20071127103940.314c7844@freepuppy.rosehill>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Hemminger wrote:
> 
> Is there any standard kernel config define for "this platform can't do
> unaligned accesses"?
> 

Not that I know of, but there should be.

To be somewhat more complexicated, some platforms (e.g. MIPS) can do 
unaligned references quite cheaply, but they need different opcodes to 
do so.

	-hpa
