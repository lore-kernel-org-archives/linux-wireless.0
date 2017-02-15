Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60828 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751175AbdBOQFW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 11:05:22 -0500
Message-ID: <1487174718.31885.4.camel@sipsolutions.net> (sfid-20170215_170525_497159_FB3E9DDA)
Subject: Re: [PATCH] mac80211:  allow overriding station bandwidth.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2017 17:05:18 +0100
In-Reply-To: <58A46F91.6090707@candelatech.com>
References: <1487106095-23287-1-git-send-email-greearb@candelatech.com>
                 (sfid-20170214_220143_477541_65E9EEB9) <1487144841.4026.1.camel@sipsolutions.net>
         <58A46F91.6090707@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Likely for some time remote third-party peers will not update with
> your patches to advertise the proper IEs, even if the local system
> does?

I think they ought to start doing that pretty soon.

> Either way, I suspect that 4x4 VHT80 may perform quite well vs 2x2
> VHT160 if there is any sort of interference on the secondary 80Mhz
> band...

True. Rate scaling should probably pick that over 160 MHz bandwidth, if
supported. But if, for example, VHT opmode notification restricts
current operation to 2x2, rate scaling should still pick 160 MHz.

> But, I can just remove the 'why' part of the description entirely if
> you prefer?

Yes, I just don't want to give people the wrong idea about this :)

johannes
