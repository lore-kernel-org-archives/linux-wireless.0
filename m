Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2512 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756683AbXK2Xnd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 18:43:33 -0500
Date: Fri, 30 Nov 2007 10:43:27 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>,
	David Miller <davem@davemloft.net>, dsd@gentoo.org,
	kune@deine-taler.de
Subject: Re: ZD1211RW unaligned accesses...
Message-ID: <20071129234327.GA23769@gondor.apana.org.au> (sfid-20071129_234339_196157_36CABDC6)
References: <20071120.040546.222294375.davem@davemloft.net> <47442BFC.8090008@hotmail.com> <20071124150216.GA28153@gondor.apana.org.au> <20071129214533.GD32730@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071129214533.GD32730@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 29, 2007 at 04:45:33PM -0500, John W. Linville wrote:
> So, did the patch below fix the problem?  Should I apply it?

I'm keen to find out the result too :)

Chances are it does make progress however we may still have the
general wireless/IP stack alignment issue that we are still discussing.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
