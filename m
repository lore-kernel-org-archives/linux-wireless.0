Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34147 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161286AbbKTCLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 21:11:13 -0500
Received: by padhx2 with SMTP id hx2so99879397pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Nov 2015 18:11:13 -0800 (PST)
Subject: Re: [PATCH 4/5] wcn3620: use new response format for wcn3620
 trigger_ba
To: Bob Copeland <me@bobcopeland.com>
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
 <1447063362-27322-5-git-send-email-fengwei.yin@linaro.org>
 <20151109154040.GD5395@localhost> <56419805.4090902@linaro.org>
 <20151110141336.GF5395@localhost> <564D3FEE.1000208@linaro.org>
 <20151119174107.GB12931@localhost> <564E7A0E.5090105@linaro.org>
 <20151120015238.GC12931@localhost>
Cc: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com
From: "fengwei.yin" <fengwei.yin@linaro.org>
Message-ID: <564E813D.1040109@linaro.org> (sfid-20151120_031118_393472_E61B169E)
Date: Fri, 20 Nov 2015 10:11:09 +0800
MIME-Version: 1.0
In-Reply-To: <20151120015238.GC12931@localhost>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015/11/20 9:52, Bob Copeland wrote:
> On Fri, Nov 20, 2015 at 09:40:30AM +0800, fengwei.yin wrote:
>> Actually, this patch was using the v1 and DragonBoard needs v2 for trigger_ba.
>> And I want to know whether the change from Andy could work on the platform
>> which is using v1.
>>
>> Can you try this change on your platform? Thanks.
>
> I'm not sure I understand -- if you look at the right side of the diff
> for the patch "wcn36xx: Parse trigger_ba response properly", it is changing
> wcn36xx_smd_rsp_status_check() to wcn36xx_smd_trigger_ba_rsp(), whose
> definition is the same as wcn36xx_smd_rsp_station_check_v2() as far as I can
> tell.  Or am I missing something?
>
Yes. Exactly. So your platform is using the v2 format as well. We may not need
to care the v1 format too much. Thanks.

Regards
Yin, Fengwei
