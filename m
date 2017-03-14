Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39580 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750925AbdCNNw0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 09:52:26 -0400
Message-ID: <1489499543.10872.5.camel@sipsolutions.net> (sfid-20170314_145705_758148_25B25F3D)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Avraham Stern <avraham.stern@intel.com>
Date: Tue, 14 Mar 2017 14:52:23 +0100
In-Reply-To: <5f34db3e-1d68-71aa-07b2-5296eaa9f533@broadcom.com> (sfid-20170309_143857_819168_765E6ED5)
References: <20170221100957.30965-1-johannes@sipsolutions.net>
         <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com>
         <1487673603.2215.3.camel@sipsolutions.net>
         <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com>
         <a021dbf9-854d-0339-b87d-b27b746ccd1b@broadcom.com>
         <1487677574.2215.4.camel@sipsolutions.net>
         <96cd71c3-c279-b298-3876-68bac7297dc4@broadcom.com>
         <1488543681.25750.3.camel@sipsolutions.net>
         <5f34db3e-1d68-71aa-07b2-5296eaa9f533@broadcom.com>
         (sfid-20170309_143857_819168_765E6ED5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> So the 4-way hs offload patches in wpa_s RFC do not make distinction
> between 1X and WPA-PSK. Can we expect drivers to support one, but not
> the other? In other words do we need the flexibility in nl80211?

You tell me :)

We're implementing both. Andrei also raised this question on the wpa_s
patches at my request, and nobody commented.

I can live with combining them, but nobody better complain about it
when they just implement one of them on their device ... :)

johannes
