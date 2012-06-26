Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:55917 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004Ab2FZOFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 10:05:53 -0400
Message-ID: <4FE9C1BF.8060209@tieto.com> (sfid-20120626_160556_330842_B625509D)
Date: Tue, 26 Jun 2012 16:05:51 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3] respect channels in iface combinations
References: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com> <1340717512.14634.38.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340717512.14634.38.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2012-06-26 at 14:30 +0200, Michal Kazior wrote:
>> Hi,
>>
>> Here's a respin of my patches.
>>
>> Changes:
>>
>>   - add libertas set_channel tracking
>>   - add channel switch notify support (ap channel tracking)
>>   - introduce CFG80211_MAX_NUM_DIFFERENT_CHANNELS
>>     (changes channel accounting a bit)
>>   - add channel accounting for assoc
>>
>> Left unchanged:
>>
>>   - set_monitor_enabled callback name
>>   - initial monitor channel is set to first one found
>
> Dziękujemy! (and thanks google too :-D)
>
> I just saw a few tiny issues, can you repost as [PATCH] and then, unless
> I see other objections, I'll pick this up.

Sure. I'll resend it as a PATCH tomorrow after fixing.



-- 
Pozdrawiam / Best regards, Michal Kazior.

