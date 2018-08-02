Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36418 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbeHBUmB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 16:42:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH v2 01/19] mt76: move MT_TXD_INFO,
 MT_MCU_MSG and MT_RX_FCE_INFO defs in dma.h
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <bcf24fdbf8a3d023fc716e65dc190756232f0645.1533023328.git.lorenzo.bianconi@redhat.com>
References: <bcf24fdbf8a3d023fc716e65dc190756232f0645.1533023328.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org, sgruszka@redhat.com
Message-Id: <20180802184938.751C8607BD@smtp.codeaurora.org> (sfid-20180802_204941_820508_62BE98EA)
Date: Thu,  2 Aug 2018 18:49:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Since MT_TXD_INFO, MT_MCU_MSG and MT_RX_FCE_INFO definitions are in
> common between mt76x2u, mt76x2 and mt76x0u move them in dma.h in order
> to reuse usb code supporting mt76x2u and mt76x0u based devices
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

19 patches applied to wireless-drivers-next.git, thanks.

66fc44b71c59 mt76: move MT_TXD_INFO, MT_MCU_MSG and MT_RX_FCE_INFO defs in dma.h
35ecee1f6755 mt76x2: move mt76x2_fw_header and mt76x2_patch_header definitions in mcu.h
2edb2ae5e60a mt76x2: move utility routines in mt76x2.h
15fdb7a07bbe mt76x2: introduce mt76x2_init_device routine
4681e0c79e43 mt76x2: move interface_modes definition in mt76x2_init
d3c94b40460b mt76x2: introduce mt76x2_mac_load_tx_status routine
81e850ef2625 mt76x2: add napi struct to mt76_rx_poll_complete/mt76_rx_complete signatures
bbd89d948108 mt76x2: add buffer len to mt76x2_mac_write_txwi signature
fcdd99ce7267 mt76: rename mt76_tx_queue_skb in mt76_dma_tx_queue_skb
469d48188625 mt76: introduce tx_queue_skb function pointer in mt76_bus_ops
d20ad5816962 mt76: introduce mt76x2-common module
9367a9c7f956 mt76: add mt76x2_tx_common to mt76x2-common module
b9c45e1c42b7 mt76: add mt76x2_mac_common to mt76x2-common module
43930193a874 mt76: add mt76x2_init_common to mt76x2-common module
2de8c3eb7ed7 mt76: add mt76x2_common to mt76x2-common module
5f0d10ceee47 mt76: add mt76x2_phy_common to mt76x2-common module
037804002b8a mt76: move mt76x2_debugfs in mt76-common module
b40b15e1521f mt76: add usb support to mt76 layer
ee676cd5017c mt76: add driver code for MT76x2u based devices

-- 
https://patchwork.kernel.org/patch/10550371/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
