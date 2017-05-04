Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:56038 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752345AbdEDPW6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 11:22:58 -0400
Date: Thu, 04 May 2017 11:22:57 -0400 (EDT)
Message-Id: <20170504.112257.1601480484804301664.davem@davemloft.net> (sfid-20170504_172442_349294_EA2D4D3F)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, torvalds@linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] cfg80211: make RATE_INFO_BW_20 the default
From: David Miller <davem@davemloft.net>
In-Reply-To: <1493911002.18881.0.camel@sipsolutions.net>
References: <20170504064230.22058-1-johannes@sipsolutions.net>
        <20170504.111333.814726752020791317.davem@davemloft.net>
        <1493911002.18881.0.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 04 May 2017 17:16:42 +0200

> On Thu, 2017-05-04 at 11:13 -0400, David Miller wrote:
>> 
>> Johannes, would you like me to merge this in via my tree directly?
> 
> I figured I'd give Linus to a chance to try or even apply it, but I
> have no objection to you applying it either. I don't have anything else
>   yet right now, and sending a pull request for just a single patch
> would be quite pointless.

Ok, let's give Linus a chance to test the patch.
