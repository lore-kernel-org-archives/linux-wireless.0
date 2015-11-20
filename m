Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35879 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758681AbbKTCMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 21:12:43 -0500
Received: by pacdm15 with SMTP id dm15so99925578pac.3
        for <linux-wireless@vger.kernel.org>; Thu, 19 Nov 2015 18:12:43 -0800 (PST)
Subject: Re: [PATCH v2 0/5] wcn36xx: add some new firmware functionalities
 support
To: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com
References: <1447143955-10304-1-git-send-email-fengwei.yin@linaro.org>
From: "fengwei.yin" <fengwei.yin@linaro.org>
Message-ID: <564E8196.9050601@linaro.org> (sfid-20151120_031247_251431_5B060392)
Date: Fri, 20 Nov 2015 10:12:38 +0800
MIME-Version: 1.0
In-Reply-To: <1447143955-10304-1-git-send-email-fengwei.yin@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eugene,

On 2015/11/10 16:25, Yin, Fengwei wrote:
> Hi,
> This patchset are from Andy Green. Which support some functionalities of
> latest wcn36xx firmware.
>
> Changelog since v1
>    - decouple the connection of wcn36xx_smd_rsp_status_check_v2 with 3620.
>      This also fix the build error.
>    - Remove additional "From" introduced in v1.
>
> Andy Green (5):
>    wcn36xx: introduce WCN36XX_HAL_AVOID_FREQ_RANGE_IND
>    wcn36xx: swallow two wcn3620 IND messages
>    wcn36xx: handle new hal response format
>    wcn3620: use new response format for wcn3620 trigger_ba
>    wcn3620: use new response format for wcn3620 remove_bsskey
>
>   drivers/net/wireless/ath/wcn36xx/hal.h |  2 ++
>   drivers/net/wireless/ath/wcn36xx/smd.c | 27 +++++++++++++++++++++++++--
>   drivers/net/wireless/ath/wcn36xx/smd.h |  9 +++++++++
>   3 files changed, 36 insertions(+), 2 deletions(-)
>

What do you think about these patches? If they are OK, can you ack them?
Thanks.


Regards
Yin, Fengwei
