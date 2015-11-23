Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34116 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbbKWGyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 01:54:45 -0500
Received: by padhx2 with SMTP id hx2so182094441pad.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2015 22:54:45 -0800 (PST)
Subject: Re: [PATCH v2 0/5] wcn36xx: add some new firmware functionalities
 support
To: Eugene Krasnikov <k.eugene.e@gmail.com>
References: <1447143955-10304-1-git-send-email-fengwei.yin@linaro.org>
 <564E8196.9050601@linaro.org>
 <CAFSJ42bMU=3KMLn++kOPKLsFA4_6-agD-J_adN3uUiXodOkvKA@mail.gmail.com>
Cc: Andy Green <andy.green@linaro.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	Bob Copeland <me@bobcopeland.com>,
	Bjorn Andersson <bjorn.andersson@sonymobile.com>
From: yfw <fengwei.yin@linaro.org>
Message-ID: <5652B82A.6080401@linaro.org> (sfid-20151123_075449_253990_69BC7FF3)
Date: Mon, 23 Nov 2015 14:54:34 +0800
MIME-Version: 1.0
In-Reply-To: <CAFSJ42bMU=3KMLn++kOPKLsFA4_6-agD-J_adN3uUiXodOkvKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015年11月23日 04:03, Eugene Krasnikov wrote:
> All 5 patches looks good to me.

Thanks a lot.

Regards
Yin, Fengwei

>
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
