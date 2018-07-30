Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41958 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbeG3QEe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 12:04:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 01/19] mt76: move MT_TXD_INFO,
 MT_MCU_MSG and MT_RX_FCE_INFO defs in dma.h
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180701141231.25323-2-lorenzo.bianconi@redhat.com>
References: <20180701141231.25323-2-lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org, sgruszka@redhat.com
Message-Id: <20180730142918.118BE61E4D@smtp.codeaurora.org> (sfid-20180730_162926_416113_72F9A2FE)
Date: Mon, 30 Jul 2018 14:29:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Since MT_TXD_INFO, MT_MCU_MSG and MT_RX_FCE_INFO definitions are in
> common between mt76x2u, mt76x2 and mt76x0u move them in dma.h in order
> to reuse usb code supporting mt76x2u and mt76x0u based devices
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Dropping as Lorenzo mentioned there will be v2

19 patches set to Changes Requested.

10498679 [01/19] mt76: move MT_TXD_INFO, MT_MCU_MSG and MT_RX_FCE_INFO defs in dma.h
10498683 [02/19] mt76x2: move mt76x2_fw_header and mt76x2_patch_header definitions in mcu.h
10498681 [03/19] mt76x2: move utility routines in mt76x2.h
10498685 [04/19] mt76x2: introduce mt76x2_init_device routine
10498689 [05/19] mt76x2: move interface_modes definition in mt76x2_init
10498687 [06/19] mt76x2: introduce mt76x2_mac_load_tx_status routine
10498691 [07/19] mt76x2: add napi struct to mt76_rx_poll_complete/mt76_rx_complete signatures
10498695 [08/19] mt76x2: add buffer len to mt76x2_mac_write_txwi signature
10498701 [09/19] mt76: rename mt76_tx_queue_skb in mt76_dma_tx_queue_skb
10498693 [10/19] mt76: introduce tx_queue_skb function pointer in mt76_bus_ops
10498699 [11/19] mt76: introduce mt76x2-common module
10498697 [12/19] mt76: add mt76x2_tx_common to mt76x2-common module
10498707 [13/19] mt76: add mt76x2_mac_common to mt76x2-common module
10498705 [14/19] mt76: add mt76x2_init_common to mt76x2-common module
10498709 [15/19] mt76: add mt76x2_common to mt76x2-common module
10498711 [16/19] mt76: add mt76x2_phy_common to mt76x2-common module
10498703 [17/19] mt76: move mt76x2_debugfs in mt76-common module
10498715 [18/19] mt76: add usb support to mt76 layer
10498713 [19/19] mt76: add driver code for MT76x2u based devices

-- 
https://patchwork.kernel.org/patch/10498679/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
