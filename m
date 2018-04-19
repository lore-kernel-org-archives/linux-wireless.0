Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60928 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753008AbeDSPzM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 11:55:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,01/13] ath10k: platform driver for WCN3990 SNOC WLAN module
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1521781424-24972-2-git-send-email-govinds@codeaurora.org>
References: <1521781424-24972-2-git-send-email-govinds@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Message-Id: <20180419155511.D6F836079B@smtp.codeaurora.org> (sfid-20180419_175515_948269_C73900CB)
Date: Thu, 19 Apr 2018 15:55:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> wrote:

> WCN3990 is integrated 802.11ac chipset with SNOC
> bus interface. Add snoc layer driver registration
> and associated ops.
> 
> WCN3990 support is not yet complete as cold-boot
> handshake is done using qmi(Qualcomm-MSM-Interface)
> and qmi client support will be added once qmi framework
> is available.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

13 patches applied to ath-next branch of ath.git, thanks.

17f5559e0da5 ath10k: platform driver for WCN3990 SNOC WLAN module
c963a683e701 ath10k: add resource init and deinit for WCN3990
a6e149a9ff03 ath10k: add hif start/stop methods for wcn3990 snoc layer
b8c27e862118 ath10k: add HTC services for WCN3990
84efe7f6ebc5 ath10k: map HTC services to tx/rx pipes for wcn3990
0fa4fbe9b8cf ath10k: add hif power-up/power-down methods
d390509bdf50 ath10k: add hif tx methods for wcn3990
d915105231ca ath10k: add hif rx methods for wcn3990
546d407c905b ath10k: modify hif tx paddr to dma_addr_t type
140d1214ef55 ath10k: add support to get target info from hif ops
ea66b12e63ac ath10k: check all CE for data if irq summary is not retained
a6a793f98786 ath10k: vote for hardware resources for WCN3990
ae316c4cbba2 dt: bindings: add bindings for wcn3990 wifi block

-- 
https://patchwork.kernel.org/patch/10302661/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
