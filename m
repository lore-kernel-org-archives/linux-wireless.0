Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1060 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762931AbYAKWxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 17:53:11 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: johannes@sipsolutions.net (Johannes Berg)
Subject: Re: handing cloned frames to netif_rx()?
Cc: netdev@vger.kernel.org, ron.rindjunsky@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1200014246.3861.148.camel@johannes.berg>
Message-Id: <E1JDSPG-0008Of-00@gondolin.me.apana.org.au> (sfid-20080111_225331_804408_0A6E271F)
Date: Sat, 12 Jan 2008 09:31:18 +1100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Is it ok to do this? Will something freak out if we pass a cloned skb to
> netif_rx()?

Sounds OK as long as you stick to the rules of cloned skb's, e.g., not
writing to them unless you've copied it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
