Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33191 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754969AbcISJen (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 05:34:43 -0400
Date: Mon, 19 Sep 2016 17:34:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
        tom@herbertland.com, Ben Greear <greearb@candelatech.com>
Subject: Re: [v2 PATCH 0/2] rhashtable: rhashtable with duplicate objects
Message-ID: <20160919093434.GA12378@gondor.apana.org.au> (sfid-20160919_113514_946295_6748FD0D)
References: <20160804071846.GA773@gondor.apana.org.au>
 <20160804074546.GA996@gondor.apana.org.au>
 <1470377813.2977.14.camel@sipsolutions.net>
 <20160805104858.GA9297@gondor.apana.org.au>
 <1470394233.2977.37.camel@sipsolutions.net>
 <20160918135030.GA7062@gondor.apana.org.au>
 <20160919084056.GA11875@gondor.apana.org.au>
 <1474276530.4469.16.camel@sipsolutions.net>
 <20160919091721.GA12235@gondor.apana.org.au>
 <1474277244.4469.21.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474277244.4469.21.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2016 at 11:27:24AM +0200, Johannes Berg wrote:
> 
> I have a feeling there's a bug with ht->nelems, since the crash is
> always in the grow worker, but I haven't quite put my finger on it yet.

Can you show me a stack trace?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
