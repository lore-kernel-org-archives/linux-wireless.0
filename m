Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35062 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbbKZAFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 19:05:03 -0500
Received: by pacej9 with SMTP id ej9so71486151pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2015 16:05:02 -0800 (PST)
Subject: Re: [PATCH v2 0/5] wcn36xx: add some new firmware functionalities
 support
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1447143955-10304-1-git-send-email-fengwei.yin@linaro.org>
 <564E8196.9050601@linaro.org>
 <CAFSJ42bMU=3KMLn++kOPKLsFA4_6-agD-J_adN3uUiXodOkvKA@mail.gmail.com>
Cc: Andy Green <andy.green@linaro.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	Bob Copeland <me@bobcopeland.com>,
	Bjorn Andersson <bjorn.andersson@sonymobile.com>
From: "fengwei.yin" <fengwei.yin@linaro.org>
Message-ID: <56564CA8.4070603@linaro.org> (sfid-20151126_010507_595504_F5FF5B60)
Date: Thu, 26 Nov 2015 08:04:56 +0800
MIME-Version: 1.0
In-Reply-To: <CAFSJ42bMU=3KMLn++kOPKLsFA4_6-agD-J_adN3uUiXodOkvKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On 2015/11/23 4:03, Eugene Krasnikov wrote:
> All 5 patches looks good to me.
>
Is it OK to take these patches? Thanks.

Regards
Yin, Fengwei

> 2015-11-20 2:12 GMT+00:00 fengwei.yin <fengwei.yin@linaro.org>:
>> Hi Eugene,
>>
>> On 2015/11/10 16:25, Yin, Fengwei wrote:
>>>
>>> Hi,
>>> This patchset are from Andy Green. Which support some functionalities of
>>> latest wcn36xx firmware.
>>>
>>> Changelog since v1
>>>     - decouple the connection of wcn36xx_smd_rsp_status_check_v2 with 3620.
>>>       This also fix the build error.
>>>     - Remove additional "From" introduced in v1.
>>>
>>> Andy Green (5):
>>>     wcn36xx: introduce WCN36XX_HAL_AVOID_FREQ_RANGE_IND
>>>     wcn36xx: swallow two wcn3620 IND messages
>>>     wcn36xx: handle new hal response format
>>>     wcn3620: use new response format for wcn3620 trigger_ba
>>>     wcn3620: use new response format for wcn3620 remove_bsskey
>>>
>>>    drivers/net/wireless/ath/wcn36xx/hal.h |  2 ++
>>>    drivers/net/wireless/ath/wcn36xx/smd.c | 27 +++++++++++++++++++++++++--
>>>    drivers/net/wireless/ath/wcn36xx/smd.h |  9 +++++++++
>>>    3 files changed, 36 insertions(+), 2 deletions(-)
>>>
>>
>> What do you think about these patches? If they are OK, can you ack them?
>> Thanks.
>>
>>
>> Regards
>> Yin, Fengwei
>
>
>
