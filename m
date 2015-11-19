Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36660 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbbKSDUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 22:20:21 -0500
Received: by pacdm15 with SMTP id dm15so65642663pac.3
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2015 19:20:21 -0800 (PST)
Subject: Re: [PATCH 4/5] wcn3620: use new response format for wcn3620
 trigger_ba
To: Bob Copeland <me@bobcopeland.com>
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
 <1447063362-27322-5-git-send-email-fengwei.yin@linaro.org>
 <20151109154040.GD5395@localhost> <56419805.4090902@linaro.org>
 <20151110141336.GF5395@localhost>
Cc: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com
From: yfw <fengwei.yin@linaro.org>
Message-ID: <564D3FEE.1000208@linaro.org> (sfid-20151119_042024_949078_5822D8FF)
Date: Thu, 19 Nov 2015 11:20:14 +0800
MIME-Version: 1.0
In-Reply-To: <20151110141336.GF5395@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob,

On 2015年11月10日 22:13, Bob Copeland wrote:
> On Tue, Nov 10, 2015 at 03:08:53PM +0800, fengwei.yin wrote:
>> Even on 3620, not all cmds switch to wcn36xx_smd_rsp_status_check_v2.
>> And I don't think wcn36xx_smd_rsp_status_check_v2 should bind to 3620 (it
>> may be related with firmware).
>>
>> In patch v2, the wcn36xx_smd_rsp_status_check_v2 is not bind to 3620. If
>> you could test on none-3620 platform (I don't have none-3620 plafrom), that
>> will be great.
>
> Sure, I'll take a look today or tomorrow on my hardware.
>

Ping...

Regards
Yin, Fengwei
