Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42750 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbeGKF5z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 01:57:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 11 Jul 2018 11:25:19 +0530
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/7] cfg80211: Add support to notify station's rssi level
 crossing
In-Reply-To: <1530877182.3197.3.camel@sipsolutions.net>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
 <1528886747-26342-5-git-send-email-tamizhr@codeaurora.org>
 <1530264922.3481.40.camel@sipsolutions.net>
 <b87dc6cea56faee0a3570d90b4e6d42a@codeaurora.org>
 <1530877182.3197.3.camel@sipsolutions.net>
Message-ID: <aa59640b8ae7a3b8f8dfc1b6ca813c4e@codeaurora.org> (sfid-20180711_075522_901234_57699E18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-06 17:09, Johannes Berg wrote:
> On Wed, 2018-07-04 at 11:43 +0530, Tamizh chelvam wrote:
> 
>> > > --- a/include/uapi/linux/nl80211.h
>> > > +++ b/include/uapi/linux/nl80211.h
>> > > @@ -1249,6 +1249,7 @@ enum nl80211_commands {
>> > >  	NL80211_CMD_CONTROL_PORT_FRAME,
>> > >
>> > >  	NL80211_CMD_SET_STA_MON,
>> > > +	NL80211_CMD_NOTIFY_STA_MON,
>> >
>> > Missing documentation - but again, why not unify it with the existing
>> > event? Or can't we because that might confuse older applications?
>> > Perhaps anyway we should unicast these notifications? Not sure though,
>> > perhaps one app could set them up and the other might care?
>> >
>> 
>> This new command introduced as per the previous discussion
>> https://patchwork.kernel.org/patch/10168685/
>> https://patchwork.kernel.org/patch/10240697/
>> 
>> Is my understanding correct ?
> 
> I guess you're right. To my defense, this was like almost half a year
> ago :)
Yeah;)
> 
>> I just referred this code from cfg80211_prepare_cqm. Do you want me to
>> change this to struct based?
> 
> Please, I guess we can fix up cqm too later.
> 
Sure, I'll fix it in the next version.

Thanks,
Tamizh.
