Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56202 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729647AbeGaIzY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 04:55:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/6] rsi: remove redundant device ids
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1531748377-29215-2-git-send-email-siva8118@gmail.com>
References: <1531748377-29215-2-git-send-email-siva8118@gmail.com>
To: Siva Rebbagondla <siva8118@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Amol Hanwate <amol.hanwate@redpinesignals.com>
Message-Id: <20180731071630.68FD160397@smtp.codeaurora.org> (sfid-20180731_091647_661189_C089AF14)
Date: Tue, 31 Jul 2018 07:16:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Siva Rebbagondla <siva8118@gmail.com> wrote:

> From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> 
> Removing redundant device id's from both usb and sdio idtables, as rsi
> driver currently supporting only one module(RS9113). Also, replaced ids
> with specific defines.
> 
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

6 patches applied to wireless-drivers-next.git, thanks.

5850874c28a4 rsi: remove redundant device ids
bae402920424 rsi: remove redundant flash_content variable
f5fbce65abcf rsi: add firmware support for AP+BT dual mode
abbe87d339bd rsi: Correct RSI_NEEDED_HEADROOM in mac80211_attach.
160ee2a11ce0 rsi: fill rx_params only once.
2ddd82eef2ef rsi: move init_done flag to end of rsi_91x_init().

-- 
https://patchwork.kernel.org/patch/10526805/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
