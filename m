Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:58073 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753774Ab2DPN2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 09:28:30 -0400
Date: Mon, 16 Apr 2012 20:48:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	driverdevel <devel@driverdev.osuosl.org>,
	wireless <linux-wireless@vger.kernel.org>,
	Jan Simonson <jan@simonson.se>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Problem with crypto when initializing TKIP
Message-ID: <20120416124839.GA5985@gondor.apana.org.au> (sfid-20120416_152833_579096_E07BAA99)
References: <4F8BAE2F.5090200@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F8BAE2F.5090200@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 16, 2012 at 12:29:19AM -0500, Larry Finger wrote:
>
> The value of ok is NOTIFY_OK, which leads to a return of -ENOENT and
> a failure of the initialization.

NOTIFY_OK means that we have no notifiers installed.  Did you
compile/load CRYPTO_MANAGER?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
