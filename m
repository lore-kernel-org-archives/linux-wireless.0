Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:32784 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbbKVUDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 15:03:53 -0500
Received: by qgea14 with SMTP id a14so103687508qge.0
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2015 12:03:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <564E8196.9050601@linaro.org>
References: <1447143955-10304-1-git-send-email-fengwei.yin@linaro.org>
	<564E8196.9050601@linaro.org>
Date: Sun, 22 Nov 2015 20:03:52 +0000
Message-ID: <CAFSJ42bMU=3KMLn++kOPKLsFA4_6-agD-J_adN3uUiXodOkvKA@mail.gmail.com> (sfid-20151122_210358_101462_7118BC1C)
Subject: Re: [PATCH v2 0/5] wcn36xx: add some new firmware functionalities support
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: "fengwei.yin" <fengwei.yin@linaro.org>
Cc: Andy Green <andy.green@linaro.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	Bob Copeland <me@bobcopeland.com>,
	Bjorn Andersson <bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All 5 patches looks good to me.

2015-11-20 2:12 GMT+00:00 fengwei.yin <fengwei.yin@linaro.org>:
> Hi Eugene,
>
> On 2015/11/10 16:25, Yin, Fengwei wrote:
>>
>> Hi,
>> This patchset are from Andy Green. Which support some functionalities of
>> latest wcn36xx firmware.
>>
>> Changelog since v1
>>    - decouple the connection of wcn36xx_smd_rsp_status_check_v2 with 3620.
>>      This also fix the build error.
>>    - Remove additional "From" introduced in v1.
>>
>> Andy Green (5):
>>    wcn36xx: introduce WCN36XX_HAL_AVOID_FREQ_RANGE_IND
>>    wcn36xx: swallow two wcn3620 IND messages
>>    wcn36xx: handle new hal response format
>>    wcn3620: use new response format for wcn3620 trigger_ba
>>    wcn3620: use new response format for wcn3620 remove_bsskey
>>
>>   drivers/net/wireless/ath/wcn36xx/hal.h |  2 ++
>>   drivers/net/wireless/ath/wcn36xx/smd.c | 27 +++++++++++++++++++++++++--
>>   drivers/net/wireless/ath/wcn36xx/smd.h |  9 +++++++++
>>   3 files changed, 36 insertions(+), 2 deletions(-)
>>
>
> What do you think about these patches? If they are OK, can you ack them?
> Thanks.
>
>
> Regards
> Yin, Fengwei



-- 
Best regards,
Eugene
