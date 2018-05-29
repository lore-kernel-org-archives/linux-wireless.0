Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52356 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeE2HVU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 03:21:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] wlcore: sdio: check for valid platform device data before
 suspend
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1527496602-25214-1-git-send-email-eyalr@ti.com>
References: <1527496602-25214-1-git-send-email-eyalr@ti.com>
To: Eyal Reizer <eyalreizer@gmail.com>
Cc: tony@atomide.com, nsekhar@ti.com, linux-wireless@vger.kernel.org,
        Eyal Reizer <eyalr@ti.com>
Message-Id: <20180529072120.1F825603D2@smtp.codeaurora.org> (sfid-20180529_092136_327415_2811BFB1)
Date: Tue, 29 May 2018 07:21:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eyal Reizer <eyalreizer@gmail.com> wrote:

> the wl pointer can be null In case only wlcore_sdio is probed while
> no WiLink module is successfully probed, as in the case of mounting a
> wl12xx module while using a device tree file configured with wl18xx
> related settings.
> In this case the system was crashing in wl1271_suspend() as platform
> device data is not set.
> Make sure wl the pointer is valid before using it.
> 
> Signed-off-by: Eyal Reizer <eyalr@ti.com>

Patch applied to wireless-drivers-next.git, thanks.

6e91d48371e7 wlcore: sdio: check for valid platform device data before suspend

-- 
https://patchwork.kernel.org/patch/10430043/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
