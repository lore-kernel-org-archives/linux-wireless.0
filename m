Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50010 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935113AbdAENj2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 08:39:28 -0500
Message-ID: <1483623500.4394.18.camel@sipsolutions.net> (sfid-20170105_143932_349232_8BD81BED)
Subject: Re: [PATCH 2/4] cfg80211: Add new NL80211_CMD_SET_BTCOEX_PRIORITY
 to support BTCOEX
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhchelvam@codeaurora.org>
Cc: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Date: Thu, 05 Jan 2017 14:38:20 +0100
In-Reply-To: <a5521b4e246de90ed8526891c84a97e5@codeaurora.org>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
         <1478610932-21954-3-git-send-email-c_traja@qti.qualcomm.com>
         <1480949353.31788.27.camel@sipsolutions.net>
         <5e5e8971c96293a81e7cb37bcdfbd593@codeaurora.org>
         <1481645351.20412.34.camel@sipsolutions.net>
         <134cc8e58ecb804b6dda0137c4c37be8@codeaurora.org>
         <1481881024.27953.14.camel@sipsolutions.net>
         <ae82112880d55451342e7a6e5a47c33f@codeaurora.org>
         <1483354130.4596.5.camel@sipsolutions.net>
         <a5521b4e246de90ed8526891c84a97e5@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > IOW - why have all these bits rather than just one?
> 
> Hardware supports data across all the access categories, this is
> just  meant for prioritising the traffic. f.e, If the fw/target has
> both wlan and bt traffic queued and if VO is  set as priority, then
> wlan VO packets will be pushed out of the radio first and then the bt
> traffic.

Exactly. So as far as *capabilities* are concerned, why do we need so
many bits?

johannes
