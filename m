Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35719 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934327AbbKTBkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 20:40:35 -0500
Received: by pacej9 with SMTP id ej9so98992338pac.2
        for <linux-wireless@vger.kernel.org>; Thu, 19 Nov 2015 17:40:34 -0800 (PST)
Subject: Re: [PATCH 4/5] wcn3620: use new response format for wcn3620
 trigger_ba
To: Bob Copeland <me@bobcopeland.com>
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
 <1447063362-27322-5-git-send-email-fengwei.yin@linaro.org>
 <20151109154040.GD5395@localhost> <56419805.4090902@linaro.org>
 <20151110141336.GF5395@localhost> <564D3FEE.1000208@linaro.org>
 <20151119174107.GB12931@localhost>
Cc: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com
From: "fengwei.yin" <fengwei.yin@linaro.org>
Message-ID: <564E7A0E.5090105@linaro.org> (sfid-20151120_024038_664031_5565BF8D)
Date: Fri, 20 Nov 2015 09:40:30 +0800
MIME-Version: 1.0
In-Reply-To: <20151119174107.GB12931@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob,

On 2015/11/20 1:41, Bob Copeland wrote:
> On Thu, Nov 19, 2015 at 11:20:14AM +0800, yfw wrote:
>> Hi Bob,
>>
>> On 2015年11月10日 22:13, Bob Copeland wrote:
>>> On Tue, Nov 10, 2015 at 03:08:53PM +0800, fengwei.yin wrote:
>>>> Even on 3620, not all cmds switch to wcn36xx_smd_rsp_status_check_v2.
>>>> And I don't think wcn36xx_smd_rsp_status_check_v2 should bind to 3620 (it
>>>> may be related with firmware).
>>>>
>>>> In patch v2, the wcn36xx_smd_rsp_status_check_v2 is not bind to 3620. If
>>>> you could test on none-3620 platform (I don't have none-3620 plafrom), that
>>>> will be great.
>>>
>>> Sure, I'll take a look today or tomorrow on my hardware.
>>>
>>
>> Ping...
>
> Oops, sorry.  I can confirm my hardware uses this format.
>
> Turns out, in my backports snapshot I was already carrying a patch for it:
>
> https://github.com/KrasnikovEugene/wcn36xx/commit/7d41270b8c3eee0f72713b4553ca047807c0a00e
>

Actually, this patch was using the v1 and DragonBoard needs v2 for trigger_ba.
And I want to know whether the change from Andy could work on the platform
which is using v1.

Can you try this change on your platform? Thanks.

Regards
Yin, Fengwei

