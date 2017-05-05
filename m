Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36928 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751458AbdEEJGY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 05:06:24 -0400
Message-ID: <1493975178.2500.0.camel@sipsolutions.net> (sfid-20170505_110650_737322_B7404EBD)
Subject: Re: [PATCH] mac80211: Create ieee80211_if_process_skb from
 ieee80211_iface_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 05 May 2017 11:06:18 +0200
In-Reply-To: <401d68b9015dc036589c99a26ef4664000cc821e.1493919003.git.joe@perches.com>
References: <401d68b9015dc036589c99a26ef4664000cc821e.1493919003.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> o Use explicit casts to proper types instead of casts to (void *)
>   and have the compiler do the implicit cast

I see no advantage in this, why? All it does is make the code longer,
and if anything changes, you have to change it in multiple places now.

johannes
