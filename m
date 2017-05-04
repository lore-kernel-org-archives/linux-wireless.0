Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56122 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751363AbdEDPQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 11:16:50 -0400
Message-ID: <1493911002.18881.0.camel@sipsolutions.net> (sfid-20170504_171738_856396_B885836F)
Subject: Re: [PATCH] cfg80211: make RATE_INFO_BW_20 the default
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, torvalds@linux-foundation.org,
        netdev@vger.kernel.org
Date: Thu, 04 May 2017 17:16:42 +0200
In-Reply-To: <20170504.111333.814726752020791317.davem@davemloft.net>
References: <20170504064230.22058-1-johannes@sipsolutions.net>
         <20170504.111333.814726752020791317.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-05-04 at 11:13 -0400, David Miller wrote:
> 
> Johannes, would you like me to merge this in via my tree directly?

I figured I'd give Linus to a chance to try or even apply it, but I
have no objection to you applying it either. I don't have anything else
  yet right now, and sending a pull request for just a single patch
would be quite pointless.

johannes
