Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:32937 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752162AbYGDJfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 05:35:09 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: davem@davemloft.net (David Miller)
Subject: Re: [PATCH 00/39]: New multiqueue TX implementation.
Cc: netdev@vger.kernel.org, vinay@linux.vnet.ibm.com,
	krkumar2@in.ibm.com, mchan@broadcom.com, Matheos.Worku@sun.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080703.000146.168093325.davem@davemloft.net>
Message-Id: <E1KEhfo-0001RJ-00@gondolin.me.apana.org.au> (sfid-20080704_113537_140967_FB15E42B)
Date: Fri, 04 Jul 2008 17:33:48 +0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller <davem@davemloft.net> wrote:
> 
> I'm finally at the point where I can post a patch series that actually
> does something and I know works for at least one card :-)
> 
> The backlog and batching bits are sidelined for the time being.
> Don't worry, we'll get back to that soon enough :)
> 
> This can all be found in:
> 
>        kernel.org:/pub/scm/linux/kernel/git/davem/net-tx-2.6.git
> 
> which uses net-next-2.6 as it's origin.

I've only had a quick look but it is clear that this stuff is
pretty awesome and fills in a major missing piece of infrastructure
that's needed to bring Linux networking into the age of multi-core.

Nice work!

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
