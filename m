Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51292 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752271AbeC0NMF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 09:12:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 27 Mar 2018 18:42:04 +0530
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/3] cfg80211/mac80211: Notify proper sta opmode change
 value
In-Reply-To: <1522155394.3050.9.camel@sipsolutions.net>
References: <1522133296-2583-1-git-send-email-tamizhr@codeaurora.org>
 <1522155394.3050.9.camel@sipsolutions.net>
Message-ID: <ad1804a2f049eb172a77b7c8935b4956@codeaurora.org> (sfid-20180327_151209_108092_0B9A4DA5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-27 18:26, Johannes Berg wrote:
> On Tue, 2018-03-27 at 12:18 +0530, Tamizh chelvam wrote:
>> Currently bw and smps_mode are u8 type value in sta_opmode_info
>> structure. This values filled in mac80211 from 
>> ieee80211_sta_rx_bandwidth
>> and ieee80211_smps_mode. These enum values are specific to mac80211 
>> and
>> userspace/cfg80211 doesn't know about that. This patchset change its
>> data type in the sta_opmode_info structure and mapping from mac80211
>> specific enum to nl80211 enum value.
> 
> Good catch.
> 
>> Tamizh chelvam (3):
>>   cfg80211: fix data type of sta_opmode_info parameter
>>   mac80211: Use proper smps_mode enum in sta opmode event
>>   mac80211: Use proper chan_width enum in sta opmode event
>> 
>> Note :
>>   * Is this mac80211 approach sufficient ? or whether some more
>>     complete cleanup would be preferred ?
> 
> Not sure what you mean? The patches look good to me.
> 
I just wanted to confirm is this approach fine or not! I'll send a patch 
format
