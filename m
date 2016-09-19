Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35712 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbcISJRb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 05:17:31 -0400
Date: Mon, 19 Sep 2016 17:17:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
        tom@herbertland.com, Ben Greear <greearb@candelatech.com>
Subject: Re: [v2 PATCH 0/2] rhashtable: rhashtable with duplicate objects
Message-ID: <20160919091721.GA12235@gondor.apana.org.au> (sfid-20160919_111735_499908_F6D9ED9A)
References: <20160804071846.GA773@gondor.apana.org.au>
 <20160804074546.GA996@gondor.apana.org.au>
 <1470377813.2977.14.camel@sipsolutions.net>
 <20160805104858.GA9297@gondor.apana.org.au>
 <1470394233.2977.37.camel@sipsolutions.net>
 <20160918135030.GA7062@gondor.apana.org.au>
 <20160919084056.GA11875@gondor.apana.org.au>
 <1474276530.4469.16.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1474276530.4469.16.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2016 at 11:15:30AM +0200, Johannes Berg wrote:
> On Mon, 2016-09-19 at 16:40 +0800, Herbert Xu wrote:
> 
> > I've tested the rhlist code with test_rhashtable but I haven't
> > tested the mac80211 conversion.  So please give it a go and see
> > if it still works.
> 
> This is still running out of memory on my test suite.
> 
> Somehow I don't see kmemleak kicking in, so I'll have to find the bug
> manually :)

What does your test suite actually do? Is it something that I
can run without special hardware?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
