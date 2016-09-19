Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49999 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753127AbcISJPi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 05:15:38 -0400
Message-ID: <1474276530.4469.16.camel@sipsolutions.net> (sfid-20160919_111542_400533_AFAE9EAA)
Subject: Re: [v2 PATCH 0/2] rhashtable: rhashtable with duplicate objects
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
        tom@herbertland.com, Ben Greear <greearb@candelatech.com>
Date: Mon, 19 Sep 2016 11:15:30 +0200
In-Reply-To: <20160919084056.GA11875@gondor.apana.org.au>
References: <20160804071846.GA773@gondor.apana.org.au>
         <20160804074546.GA996@gondor.apana.org.au>
         <1470377813.2977.14.camel@sipsolutions.net>
         <20160805104858.GA9297@gondor.apana.org.au>
         <1470394233.2977.37.camel@sipsolutions.net>
         <20160918135030.GA7062@gondor.apana.org.au>
         <20160919084056.GA11875@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-09-19 at 16:40 +0800, Herbert Xu wrote:

> I've tested the rhlist code with test_rhashtable but I haven't
> tested the mac80211 conversion.  So please give it a go and see
> if it still works.

This is still running out of memory on my test suite.

Somehow I don't see kmemleak kicking in, so I'll have to find the bug
manually :)

johannes
