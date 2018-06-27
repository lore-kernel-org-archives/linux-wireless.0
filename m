Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41290 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752937AbeF0Pq5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 11:46:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/8] wlcore: Add missing PM call for
 wlcore_cmd_wait_for_event_or_timeout()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180619094342.81831-2-tony@atomide.com>
References: <20180619094342.81831-2-tony@atomide.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Message-Id: <20180627154656.9E51960714@smtp.codeaurora.org> (sfid-20180627_174700_986805_33677A33)
Date: Wed, 27 Jun 2018 15:46:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tony Lindgren <tony@atomide.com> wrote:

> Otherwise we can get:
> 
> WARNING: CPU: 0 PID: 55 at drivers/net/wireless/ti/wlcore/io.h:84
> 
> I've only seen this few times with the runtime PM patches enabled
> so this one is probably not needed before that. This seems to
> work currently based on the current PM implementation timer. Let's
> apply this separately though in case others are hitting this issue.
> 
> Signed-off-by: Tony Lindgren <tony@atomide.com>

8 patches applied to wireless-drivers-next.git, thanks.

4ec7cece87b3 wlcore: Add missing PM call for wlcore_cmd_wait_for_event_or_timeout()
02edf81362fe wlcore: Make sure PM calls are paired
fa2648a34e73 wlcore: Add support for runtime PM
3ebbabea4219 wlcore: Fix misplaced PM call for scan_complete_work()
db68052bdf58 wlcore: Fix timout errors after recovery
45aa7f071b06 wlcore: Use generic runtime pm calls for wowlan elp configuration
c40aad28a3cf wlcore: Make sure firmware is initialized in wl1271_op_add_interface()
9b71578de087 wlcore: Enable runtime PM autosuspend support

-- 
https://patchwork.kernel.org/patch/10473893/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
