Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52968 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728370AbeICVPN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 17:15:13 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ath10k: retrieve MAC address from firmware if provided
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180810233948.144792-1-briannorris@chromium.org>
References: <20180810233948.144792-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20180903165416.316F3606CF@smtp.codeaurora.org> (sfid-20180903_185630_177032_11EA3953)
Date: Mon,  3 Sep 2018 16:54:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:

> Devices may provide their own MAC address via system firmware (e.g.,
> device tree), especially in the case where the device doesn't have a
> useful EEPROM on which to store its MAC address (e.g., for integrated
> Wifi).
> 
> Use the generic device helper to retrieve the MAC address, and (if
> present) honor it above the MAC address advertised by the card.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

9d5804662ce1 ath10k: retrieve MAC address from system firmware if provided

-- 
https://patchwork.kernel.org/patch/10563221/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
