Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53388 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752020AbdKWOYN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Nov 2017 09:24:13 -0500
Message-ID: <1511447043.2841.2.camel@sipsolutions.net> (sfid-20171123_152458_334852_1FC4FD46)
Subject: Re: kernel BUG at crypto/asymmetric_keys/public_key.c:80
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Fainelli <f.fainelli@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        linux-wireless@vger.kernel.org
Date: Thu, 23 Nov 2017 15:24:03 +0100
In-Reply-To: <a95ae21a-c9f7-4e01-98f1-469201e20615@gmail.com> (sfid-20171123_000726_403126_550BBF6C)
References: <d2b989b6-38cf-a04d-0353-3540fdb891ed@gmail.com>
         <2ef18f35-bb00-2f4b-45fe-1beb3cdd0745@broadcom.com>
         <1511376145.2841.1.camel@sipsolutions.net>
         <a95ae21a-c9f7-4e01-98f1-469201e20615@gmail.com>
         (sfid-20171123_000726_403126_550BBF6C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-11-22 at 15:07 -0800, Florian Fainelli wrote:
> On 11/22/2017 10:42 AM, Johannes Berg wrote:
> > On Wed, 2017-11-22 at 19:29 +0100, Arend van Spriel wrote:
> > > + Johannes
> > > 
> > >  >>>     BUG_ON(!sig->digest);
> > >          BUG_ON(!sig->s);
> > 
> > I *think* this is the same bug that was reported before, then this
> > should fix it:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=d7be102f2945a626f55e0501e52bb31ba3e77b81
> > 
> > Can you try?
> 
> My baseline already has this commit actually, is there something else
> you would want me to check?

Hmm, different problem then - could you put the entire boot log
somewhere I can read it?

johannes
