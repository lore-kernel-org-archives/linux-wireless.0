Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59835 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756077Ab0DFAjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Apr 2010 20:39:51 -0400
Date: Tue, 6 Apr 2010 08:39:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavel Roskin <proski@gnu.org>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Convert arc4 from a cipher into a block cipher
Message-ID: <20100406003939.GA21130@gondor.apana.org.au>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc> <1270499625.28743.37.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1270499625.28743.37.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 05, 2010 at 04:33:45PM -0400, Pavel Roskin wrote:
>
> Are you trying to speed up arc4?  Or you want to simplify the code?  Or
> maybe you are trying to make arc4 unsuitable for anything other than WEP
> and TKIP?  The later should be fine, actually, considering the known
> security issues.

No the point is to make arc4 compliant with the crypto API by
being reentrant.

Functionality-wise there is no difference.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
