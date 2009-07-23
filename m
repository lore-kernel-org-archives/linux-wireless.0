Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39052 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751079AbZGWMTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 08:19:18 -0400
Date: Thu, 23 Jul 2009 20:19:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix autoloading of crypto modules for WEP
Message-ID: <20090723121907.GA13839@gondor.apana.org.au>
References: <4A677126.3040907@linuxtv.org> <1248294007.19121.9.camel@johannes.local> <20090723004046.GA8201@gondor.apana.org.au> <4A684BF4.9080802@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A684BF4.9080802@linuxtv.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2009 at 01:39:32PM +0200, Andreas Oberritter wrote:
> 
> http://git.opendreambox.org/?p=obi/linux.git;a=shortlog;h=refs/heads/linux-dm8000-2.6.30
> 
> I've attached my config file for you.

Thanks.

Please try

	modprobe tcrypt mode=16

That should do exactly the same thing as the wireless module
and load ecb(arc4).  If that succeeds, please try loading the
wireless module by hand to see if the failure only occurs during
the boot process.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
