Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60697 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934308AbcIZPrM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 11:47:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/5] wlcore: Prepare family to fix nvs file handling
In-Reply-To: <20160917160633.8767-2-tony@atomide.com> (Tony Lindgren's message
        of "Sat, 17 Sep 2016 09:06:29 -0700")
References: <20160917160633.8767-1-tony@atomide.com>
        <20160917160633.8767-2-tony@atomide.com>
Date: Mon, 26 Sep 2016 18:47:06 +0300
Message-ID: <878tuezmrp.fsf@kamboji.qca.qualcomm.com> (sfid-20160926_174716_597695_1358C8C8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tony Lindgren <tony@atomide.com> writes:

> Move struct wilink_family_data to be available for all TI WLAN
> variants. And fix familiy typo, it should be just family.
>
> Looks like wl12xx use two different nvs.bin files and wl18xx
> uses a different conf.bin file.
>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Applied to wireless-drivers-next.git, thanks.

-- 
Kalle Valo
