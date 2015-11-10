Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35433 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbbKJONw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 09:13:52 -0500
Received: by qgec40 with SMTP id c40so111159112qge.2
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2015 06:13:51 -0800 (PST)
Date: Tue, 10 Nov 2015 09:13:36 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "fengwei.yin" <fengwei.yin@linaro.org>
Cc: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com
Subject: Re: [PATCH 4/5] wcn3620: use new response format for wcn3620
 trigger_ba
Message-ID: <20151110141336.GF5395@localhost> (sfid-20151110_151356_149646_FE26A2A4)
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
 <1447063362-27322-5-git-send-email-fengwei.yin@linaro.org>
 <20151109154040.GD5395@localhost>
 <56419805.4090902@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56419805.4090902@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 10, 2015 at 03:08:53PM +0800, fengwei.yin wrote:
> Even on 3620, not all cmds switch to wcn36xx_smd_rsp_status_check_v2.
> And I don't think wcn36xx_smd_rsp_status_check_v2 should bind to 3620 (it
> may be related with firmware).
> 
> In patch v2, the wcn36xx_smd_rsp_status_check_v2 is not bind to 3620. If
> you could test on none-3620 platform (I don't have none-3620 plafrom), that
> will be great.

Sure, I'll take a look today or tomorrow on my hardware.

-- 
Bob Copeland %% http://bobcopeland.com/
