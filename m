Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33394 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbbKKAhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 19:37:34 -0500
Received: by pabfh17 with SMTP id fh17so13101393pab.0
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2015 16:37:34 -0800 (PST)
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
From: "fengwei.yin" <fengwei.yin@linaro.org>
Message-ID: <56428DC7.6050009@linaro.org> (sfid-20151111_013737_696953_C5435CB8)
Date: Wed, 11 Nov 2015 08:37:27 +0800
MIME-Version: 1.0
In-Reply-To: <20151110141336.GF5395@localhost>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob,

On 2015/11/10 22:13, Bob Copeland wrote:
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
Thanks a lot.

>
