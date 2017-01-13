Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51210 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750757AbdAMN5N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 08:57:13 -0500
Message-ID: <1484315830.8670.4.camel@sipsolutions.net> (sfid-20170113_145716_395402_E7BFB4D1)
Subject: Re: [PATCH v2] mac80211: prevent skb/txq mismatch
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        mohammed@qti.qualcomm.com
Date: Fri, 13 Jan 2017 14:57:10 +0100
In-Reply-To: <1484310771-28359-1-git-send-email-michal.kazior@tieto.com> (sfid-20170113_133141_348815_382CFA78)
References: <1484231321-3179-1-git-send-email-michal.kazior@tieto.com>
         <1484310771-28359-1-git-send-email-michal.kazior@tieto.com>
         (sfid-20170113_133141_348815_382CFA78)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-01-13 at 13:32 +0100, Michal Kazior wrote:
> Station structure is considered as not uploaded
> (to driver) until drv_sta_state() finishes. This
> call is however done after the structure is
> attached to mac80211 internal lists and hashes.
> This means mac80211 can lookup (and use) station
> structure before it is uploaded to a driver.
> 
[...]

Applied, thanks.

johannes
