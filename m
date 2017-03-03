Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39700 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752002AbdCCNbZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 08:31:25 -0500
Message-ID: <1488544158.25750.6.camel@sipsolutions.net> (sfid-20170303_143142_777747_D0A53AAB)
Subject: Re: [RFCv2 1/2] mac80211: Add provision for 802.11 encap offload
From: Johannes Berg <johannes@sipsolutions.net>
To: mpubbise@qti.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Date: Fri, 03 Mar 2017 13:29:18 +0100
In-Reply-To: <1488540807-27415-2-git-send-email-mpubbise@qti.qualcomm.com>
References: <1488540807-27415-1-git-send-email-mpubbise@qti.qualcomm.com>
         <1488540807-27415-2-git-send-email-mpubbise@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-03 at 17:03 +0530, mpubbise@qti.qualcomm.com wrote:
> From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> 
> Drivers can have the capability to offload 802.11 encap
> to firmware or hardware for data frames. This patch adds a new
> hw_flag for driver to advertise the offload support.
> Transmit path offloading 802.11 header (including cipher headers)
> encap for data frames will be implemented in a separate patch.
> 
> Drivers advertising this capability should also implement other
> functionalities which deal with 802.11 frame format like below
> 
>         - Hardware encryption
>         - Aggregation of A-MSDU offload
>         - Fragmentation offload

Not much point in having this as a separate patch, but this
documentation paragraph should move into the documentation for the new
flag in mac80211.h

johannes
