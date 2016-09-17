Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48925 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbcIQPYz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 11:24:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/5] Fix wlcore config firwmare annoyances
References: <20160913215043.29454-1-tony@atomide.com>
Date: Sat, 17 Sep 2016 18:24:49 +0300
In-Reply-To: <20160913215043.29454-1-tony@atomide.com> (Tony Lindgren's
        message of "Tue, 13 Sep 2016 14:50:38 -0700")
Message-ID: <87k2ea7dmm.fsf@kamboji.qca.qualcomm.com> (sfid-20160917_172500_299699_C438B4F6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tony Lindgren <tony@atomide.com> writes:

> Hi all,
>
> Here are some patches to fix the firmware loading for wl12xx/wl18xx
> when the same rootfs is used on multiple WLAN chip variants.
>
> Regards,
>
> Tony
>
> Tony Lindgren (5):
>   wlcore: Prepare family to fix nvs file handling
>   wlcore: sdio: Populate config firmware data
>   wlcore: sdio: Populate config firmware data
>   wlcore: Fix config firmware loading issues
>   wlcore: wl18xx: Use chip specific configuration firmware

I saw a new warning which I think is a valid one:

drivers/net/wireless/ti/wlcore/main.c: In function 'wlcore_probe':
drivers/net/wireless/ti/wlcore/main.c:6518:6: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]

-- 
Kalle Valo
