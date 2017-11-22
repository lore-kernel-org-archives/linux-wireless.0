Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:44541 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752394AbdKVXH1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 18:07:27 -0500
Subject: Re: kernel BUG at crypto/asymmetric_keys/public_key.c:80
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        linux-wireless@vger.kernel.org
References: <d2b989b6-38cf-a04d-0353-3540fdb891ed@gmail.com>
 <2ef18f35-bb00-2f4b-45fe-1beb3cdd0745@broadcom.com>
 <1511376145.2841.1.camel@sipsolutions.net>
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a95ae21a-c9f7-4e01-98f1-469201e20615@gmail.com> (sfid-20171123_000821_646748_DD153C1F)
Date: Wed, 22 Nov 2017 15:07:20 -0800
MIME-Version: 1.0
In-Reply-To: <1511376145.2841.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/22/2017 10:42 AM, Johannes Berg wrote:
> On Wed, 2017-11-22 at 19:29 +0100, Arend van Spriel wrote:
>> + Johannes
>>
>>  >>>     BUG_ON(!sig->digest);
>>          BUG_ON(!sig->s);
> 
> I *think* this is the same bug that was reported before, then this
> should fix it:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=d7be102f2945a626f55e0501e52bb31ba3e77b81
> 
> Can you try?

My baseline already has this commit actually, is there something else
you would want me to check?

Thanks!
-- 
Florian
