Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39288 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752885AbdIYE5U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 00:57:20 -0400
Date: Mon, 25 Sep 2017 12:56:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Xiang Gao <qasdfgtyuiop@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] mac80211: aead api to reduce redundancy
Message-ID: <20170925045641.GB22947@gondor.apana.org.au> (sfid-20170925_070739_188368_FA6D4B6C)
References: <20170924054015.8958-1-qasdfgtyuiop@gmail.com>
 <1506265531.2909.5.camel@sipsolutions.net>
 <CAMtaSwR4YTgh9N9x8a12R4dEZNuarjwvfOmnO6vnaDffVV-j3w@mail.gmail.com>
 <1506274966.2909.7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506274966.2909.7.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 24, 2017 at 07:42:46PM +0200, Johannes Berg wrote:
>
> Unrelated to this, I'm not sure whose tree this should go through -
> probably Herbert's (or DaveM's with his ACK? not sure if there's a
> crypto tree?) or so?

Since you're just rearranging code invoking the crypto API, rather
than touching actual crypto API code, I think you should handle it
as you do with any other wireless patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
