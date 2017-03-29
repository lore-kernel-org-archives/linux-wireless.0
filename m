Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42838 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbdC2IsS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 04:48:18 -0400
Message-ID: <1490777276.7948.12.camel@sipsolutions.net> (sfid-20170329_105117_936637_11D0CD1F)
Subject: Re: [PATCH v3 4/4] mac80211-hwsim: add length checks before
 allocating skb.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Mar 2017 10:47:56 +0200
In-Reply-To: <1490311578-18926-4-git-send-email-greearb@candelatech.com>
References: <1490311578-18926-1-git-send-email-greearb@candelatech.com>
         <1490311578-18926-4-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-03-23 at 16:26 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Modify the receive-from-user-space logic to do length
> and 'is-down' checks before trying to allocate an skb.
> 
> And, if we are going to ignore the pkt due to radio idle,
> then do not return an error code to user-space.  User-space
> cannot reliably know exactly when a radio is idle or not.
> 
Makes sense, but doesn't apply separately.

johannes
