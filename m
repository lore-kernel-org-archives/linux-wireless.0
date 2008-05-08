Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53907 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760961AbYEHNI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 09:08:56 -0400
Date: Thu, 8 May 2008 21:08:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH] mac80211: rewrite fragmentation code
Message-ID: <20080508130846.GA3769@gondor.apana.org.au> (sfid-20080508_150802_189514_A5C3A1E5)
References: <20080430124055.091382000@sipsolutions.net> <200805071548.06693.mb@bu3sch.de> <20080508032208.GA401@gondor.apana.org.au> <200805081500.00682.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200805081500.00682.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 08, 2008 at 03:00:00PM +0200, Michael Buesch wrote:
>
> Ok, what about DMA error. kmalloc error or something else?
> ring overflow was a bad example, of course.

If your NIC gets DMA errors all the time then I suggest you
invest in some new hardware.  Ditto if you fail to kmalloc all
the time.

If they're rare as they should be then dropping the packet is
perfectly reasonable.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
