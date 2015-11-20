Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35670 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759152AbbKTBwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 20:52:42 -0500
Received: by ioc74 with SMTP id 74so109234021ioc.2
        for <linux-wireless@vger.kernel.org>; Thu, 19 Nov 2015 17:52:42 -0800 (PST)
Date: Thu, 19 Nov 2015 20:52:38 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "fengwei.yin" <fengwei.yin@linaro.org>
Cc: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com
Subject: Re: [PATCH 4/5] wcn3620: use new response format for wcn3620
 trigger_ba
Message-ID: <20151120015238.GC12931@localhost> (sfid-20151120_025246_089861_F87C2191)
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
 <1447063362-27322-5-git-send-email-fengwei.yin@linaro.org>
 <20151109154040.GD5395@localhost>
 <56419805.4090902@linaro.org>
 <20151110141336.GF5395@localhost>
 <564D3FEE.1000208@linaro.org>
 <20151119174107.GB12931@localhost>
 <564E7A0E.5090105@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <564E7A0E.5090105@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 20, 2015 at 09:40:30AM +0800, fengwei.yin wrote:
> Actually, this patch was using the v1 and DragonBoard needs v2 for trigger_ba.
> And I want to know whether the change from Andy could work on the platform
> which is using v1.
> 
> Can you try this change on your platform? Thanks.

I'm not sure I understand -- if you look at the right side of the diff
for the patch "wcn36xx: Parse trigger_ba response properly", it is changing
wcn36xx_smd_rsp_status_check() to wcn36xx_smd_trigger_ba_rsp(), whose
definition is the same as wcn36xx_smd_rsp_station_check_v2() as far as I can
tell.  Or am I missing something?

-- 
Bob Copeland %% http://bobcopeland.com/
