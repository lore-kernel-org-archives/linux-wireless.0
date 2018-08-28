Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56680 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbeH1QQY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 12:16:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 28 Aug 2018 17:54:58 +0530
From: Sathishkumar Muruganandam <murugana@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, 'Felix Fietkau' <nbd@nbd.name>
Subject: Re: [PATCH] mac80211: WFA Multi-AP backhaul STA Rx requirement
In-Reply-To: <1535457328.5895.35.camel@sipsolutions.net>
References: <1534423635-28222-1-git-send-email-murugana@codeaurora.org>
 (sfid-20180816_144745_205490_C47B9321)
 <1535450281.5895.34.camel@sipsolutions.net>
 <003d01d43ec5$ab42fb00$01c8f100$@codeaurora.org>
 <1535457328.5895.35.camel@sipsolutions.net>
Message-ID: <f5415f760940d70872c907c64f1042fc@codeaurora.org> (sfid-20180828_142502_295002_73ACE87C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-28 17:25, Johannes Berg wrote:
> On Tue, 2018-08-28 at 17:22 +0530, murugana@codeaurora.org wrote:
>> Hi Johannes,
>> 
>> > Hmm. The subject/patch title isn't very clear - does it *implement* this
>> > requirement? Or do something else with it? Please clarify.
>> >
>> 
>> Yes, this patch implements the missing Rx requirement (ii) for 
>> backhaul STA
>> below.
>> 
> Right. Can you clean up the commit log a bit and in particular clarify
> the subject please?

Sure, Johannes. Please check my patch v2, mac80211: add missing WFA 
Multi-AP
backhaul STA Rx requirement.

-- 
Thanks,
Sathishkumar
