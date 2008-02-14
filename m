Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54915 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759941AbYBNXmN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 18:42:13 -0500
Date: Fri, 15 Feb 2008 07:41:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	Adam Turk <bofh1234@hotmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: kernel 2.6.25-rc1 and no /dev/rt73usb
Message-ID: <20080214234153.GA8020@gondor.apana.org.au> (sfid-20080214_234220_145001_F958954E)
References: <BAY101-W101597BA2B1DDD58D6F497C8250@phx.gbl> <1202952347.29519.5.camel@dv> <BAY101-W1421BB30E73369FE0A2E3DC8250@phx.gbl> <a32f33a40802140149w48a1ee51idf4a7fd0619879f3@mail.gmail.com> <1202999511.8931.128.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1202999511.8931.128.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 14, 2008 at 03:31:51PM +0100, Johannes Berg wrote:
>
> call to fail? We're doing
> 
>         select CRYPTO
>         select CRYPTO_ECB
>         select CRYPTO_ARC4
> 
> which afaik should be fine.

Yes I think so too.  Could you forward me the complete config
file please?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
