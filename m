Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39542 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755231AbYEPMPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 08:15:44 -0400
Date: Fri, 16 May 2008 20:15:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, ron.rindjunsky@intel.com, tomasw@gmail.com,
	ivdoorn@gmail.com, peter.p.waskiewicz.jr@intel.com
Subject: Re: [PATCH] mac80211: rewrite fragmentation code
Message-ID: <20080516121528.GA9768@gondor.apana.org.au> (sfid-20080516_141730_705452_243A3389)
References: <20080508032208.GA401@gondor.apana.org.au> <200805161201.48835.rusty@rustcorp.com.au> <20080515.215823.28841530.davem@davemloft.net> <200805162032.48469.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200805162032.48469.rusty@rustcorp.com.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 16, 2008 at 08:32:48PM +1000, Rusty Russell wrote:
> 
> But it's *simple*, and seems like a common thing to want.  Why not change 
> everything to use TX_BUSY and rip out the guestimate/buffering hacks?

I think this sounds quite reasonable.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
