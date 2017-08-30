Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0046.outbound.protection.outlook.com ([104.47.41.46]:52803
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751463AbdH3SWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 14:22:24 -0400
Subject: Re: [PATCH 00/27] qtnfmac: allow to configure channel, BW, HT/VHT
 caps
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <87ziahni8p.fsf@purkki.adurom.net> <87val5nhyq.fsf@purkki.adurom.net>
 <87r2vtnho6.fsf@purkki.adurom.net>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <874f62ce-f9e9-3248-56bf-fc67ddf74497@quantenna.com> (sfid-20170830_202228_640646_CE648DE8)
Date: Wed, 30 Aug 2017 11:22:17 -0700
MIME-Version: 1.0
In-Reply-To: <87r2vtnho6.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/2017 09:28 AM, Kalle Valo wrote:
> 
> External Email
> 
> 
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
>> Kalle Valo <kvalo@codeaurora.org> writes:
>>
>>> igor.mitsyanko.os@quantenna.com writes:
>>>
>>>> This patchset has a goal to make operational parameters (channel, BW,
>>>> HT/VHT capabilities) configuration possible for qtnfmac driver.
>>>> Basically the idea is to make driver level as thin as possible, and let
>>>> everything to be handled by userspace/nl80211 and wireless device itself.
>>>
>>> This patchset is just too big and pain to review. Preferably no more
>>> than 10-12 patches per set, please. If the patches bigger then the limit
>>> should be even lower.
>>
>> And I noticed that patch 25 didn't make it to patchwork:
>>
>> https://patchwork.kernel.org/project/linux-wireless/list/?state=*&q=qtnfmac
> 
> Actually it did but it was an nl80211 patch:
> 
> https://patchwork.kernel.org/patch/9921179/
> 
> Never ever hide mac80211 or cfg80211 patches within driver patches like
> this. They need to be submitted separately so that everyone sees them.
> 
> In some cases it makes sense to submit the driver patches using the new
> cfg80211/mac80211 feature at the same, but then do it so that you have
> the cfg80211/mac80211 patches and the corresponding driver patches as
> last. In that case I assign the whole patchset first to Johannes and
> once he has applied the cfg80211/mac80211 patches he assigns the driver
> patches to me.

Ok, understood.

> 
> --
> Kalle Valo
> 
