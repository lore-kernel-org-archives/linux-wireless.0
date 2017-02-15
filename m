Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56506 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751210AbdBOI1r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 03:27:47 -0500
Message-ID: <1487147264.4026.13.camel@sipsolutions.net> (sfid-20170215_092752_438400_77C6DF48)
Subject: Re: [PATCH v6 1/3] cfg80211: Accept multiple RSSI thresholds for CQM
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2017 09:27:44 +0100
In-Reply-To: <20170210090231.14696-1-andrew.zaborowski@intel.com> (sfid-20170210_101101_760570_9DF3251F)
References: <20170210090231.14696-1-andrew.zaborowski@intel.com>
         (sfid-20170210_101101_760570_9DF3251F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-02-10 at 10:02 +0100, Andrew Zaborowski wrote:
> Change the SET CQM command's RSSI threshold attribute to accept any
> number of thresholds as a sorted array.  The API should be backwards
> compatible so that if one s32 threshold value is passed, the old
> mechanism is enabled.  The netlink event generated is the same in
> both cases.

I've applied this now, thanks for your patience :)

I got a bit confused - and then fixed it up - patchwork has giving your
name as "Andrzej Zaborowski" which apparently you didn't really want
(any more). I've fixed it for these patches to be as the patches you
sent, but no guarantees I've done this before or will remember to do
that in the future - if you can somehow change your name in patchwork
(patchwork.kernel.org) that would be good.

johannes
