Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42134 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2F1LLm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 07:11:42 -0400
Message-ID: <4FEC3BEC.2070906@tieto.com> (sfid-20120628_131150_672079_7E3F65B1)
Date: Thu, 28 Jun 2012 13:11:40 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] respect channels in iface combinations
References: <1340878025-2695-1-git-send-email-michal.kazior@tieto.com> <1340879319.4491.38.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340879319.4491.38.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2012-06-28 at 12:06 +0200, Michal Kazior wrote:
>> Hi,
>>
>> The patchset introduces channel tracking per interface which is needed
>> to start enforcing num_different_channels in interface combinations.
>> Changes to monitor mode behaviour is also required for sane channel
>> accounting (considering how mac80211 handles monitor interfaces).
>>
>> This prepares cfg80211 for multi-channel operation.
>
> This didn't apply cleanly on mac80211-next due to preset_chan in
> net/wireless/cfg80211.h. I think it's just context, but if you developed
> this without the start_ap series I wonder how stop_ap makes much sense?
>
> I'm a bit confused now?

This is strange. I did develop it with the start_ap patches (my base is 
master-2012-06-14 on wireless-next). I may be missing a few from your 
mac80211 repo though.


-- 
Pozdrawiam / Best regards, Michal Kazior.

