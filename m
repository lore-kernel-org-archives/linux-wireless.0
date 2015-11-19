Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:33418 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbbKSRlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 12:41:09 -0500
Received: by qgea14 with SMTP id a14so55941215qge.0
        for <linux-wireless@vger.kernel.org>; Thu, 19 Nov 2015 09:41:08 -0800 (PST)
Date: Thu, 19 Nov 2015 12:41:07 -0500
From: Bob Copeland <me@bobcopeland.com>
To: yfw <fengwei.yin@linaro.org>
Cc: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com
Subject: Re: [PATCH 4/5] wcn3620: use new response format for wcn3620
 trigger_ba
Message-ID: <20151119174107.GB12931@localhost> (sfid-20151119_184113_858804_03C8CD03)
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
 <1447063362-27322-5-git-send-email-fengwei.yin@linaro.org>
 <20151109154040.GD5395@localhost>
 <56419805.4090902@linaro.org>
 <20151110141336.GF5395@localhost>
 <564D3FEE.1000208@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <564D3FEE.1000208@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 19, 2015 at 11:20:14AM +0800, yfw wrote:
> Hi Bob,
> 
> On 2015年11月10日 22:13, Bob Copeland wrote:
> >On Tue, Nov 10, 2015 at 03:08:53PM +0800, fengwei.yin wrote:
> >>Even on 3620, not all cmds switch to wcn36xx_smd_rsp_status_check_v2.
> >>And I don't think wcn36xx_smd_rsp_status_check_v2 should bind to 3620 (it
> >>may be related with firmware).
> >>
> >>In patch v2, the wcn36xx_smd_rsp_status_check_v2 is not bind to 3620. If
> >>you could test on none-3620 platform (I don't have none-3620 plafrom), that
> >>will be great.
> >
> >Sure, I'll take a look today or tomorrow on my hardware.
> >
> 
> Ping...

Oops, sorry.  I can confirm my hardware uses this format.

Turns out, in my backports snapshot I was already carrying a patch for it:

https://github.com/KrasnikovEugene/wcn36xx/commit/7d41270b8c3eee0f72713b4553ca047807c0a00e

-- 
Bob Copeland %% http://bobcopeland.com/
