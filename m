Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60480 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752343AbeC0M4i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 08:56:38 -0400
Message-ID: <1522155394.3050.9.camel@sipsolutions.net> (sfid-20180327_145645_963601_DFACEB0D)
Subject: Re: [RFC 0/3] cfg80211/mac80211: Notify proper sta opmode change
 value
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Mar 2018 14:56:34 +0200
In-Reply-To: <1522133296-2583-1-git-send-email-tamizhr@codeaurora.org>
References: <1522133296-2583-1-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-03-27 at 12:18 +0530, Tamizh chelvam wrote:
> Currently bw and smps_mode are u8 type value in sta_opmode_info
> structure. This values filled in mac80211 from ieee80211_sta_rx_bandwidth
> and ieee80211_smps_mode. These enum values are specific to mac80211 and
> userspace/cfg80211 doesn't know about that. This patchset change its
> data type in the sta_opmode_info structure and mapping from mac80211
> specific enum to nl80211 enum value.

Good catch.

> Tamizh chelvam (3):
>   cfg80211: fix data type of sta_opmode_info parameter
>   mac80211: Use proper smps_mode enum in sta opmode event
>   mac80211: Use proper chan_width enum in sta opmode event
> 
> Note :
>   * Is this mac80211 approach sufficient ? or whether some more
>     complete cleanup would be preferred ?

Not sure what you mean? The patches look good to me.

johannes
