Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60228 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756351AbYEHDWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 23:22:21 -0400
Date: Thu, 8 May 2008 11:22:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH] mac80211: rewrite fragmentation code
Message-ID: <20080508032208.GA401@gondor.apana.org.au> (sfid-20080508_052147_261219_3F6BE8C9)
References: <20080430124055.091382000@sipsolutions.net> <1210161133.5642.19.camel@johannes.berg> <20080507130548.GA26977@gondor.apana.org.au> <200805071548.06693.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200805071548.06693.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 07, 2008 at 03:48:06PM +0200, Michael Buesch wrote:
>
> So there's no way to actually fail in a TX handler? Drivers
> are doomed to drop the packet, if they cannot handle it due to
> ring overflow?

You're supposed to stop the queue before the ring overflows.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
