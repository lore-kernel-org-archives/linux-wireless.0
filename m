Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37282 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751422AbdB0PYh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 10:24:37 -0500
Message-ID: <1488206288.28431.15.camel@sipsolutions.net> (sfid-20170227_162544_872782_9256C692)
Subject: Re: [PATCH 1/3] cfg80211: Make pre-CAC results valid only for ETSI
 domain
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 Feb 2017 15:38:08 +0100
In-Reply-To: <1487587155-30487-2-git-send-email-vthiagar@qti.qualcomm.com>
References: <1487587155-30487-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1487587155-30487-2-git-send-email-vthiagar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-02-20 at 16:09 +0530, Vasanthakumar Thiagarajan wrote:
> DFS requirement for ETSI domain (section 4.7.1.4 in
> ETSI EN 301 893 V1.8.1) is the only one which explicitly
> states that once DFS channel is marked as available afer
> the CAC, this channel will remain in available state even
> moving to a different operating channel. But the same is
> not explicitly stated in FCC DFS requirement. Also, Pre-CAC
> requriements are not explicitly mentioned in FCC requirement.
> Current implementation in keeping DFS channel in available
> state is same as described in ETSI domain.
> 
> For ETSI DFS domain, this patch gives a grace period of 2 seconds

You mean non-ETSI, right?

Just making sure I understood correctly - no need to resend, I can fix
that.

johannes
