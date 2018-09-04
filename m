Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbeIDMgV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 08:36:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 01/16] mt76: move mt76_reg_pair definition in mt76.h
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180825104056.9130-2-lorenzo.bianconi@redhat.com>
References: <20180825104056.9130-2-lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Message-Id: <20180904081221.4F3EB60708@smtp.codeaurora.org> (sfid-20180904_101229_444858_55174392)
Date: Tue,  4 Sep 2018 08:12:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Move common definition of mt76_reg_pair in mt76.h
> and remove duplicated code in mt76x2_init_common.c
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

16 patches applied to wireless-drivers-next.git, thanks.

5090efa4a2e8 mt76: move mt76_reg_pair definition in mt76.h
4c89ff2c74e3 mt76: split __mt76u_mcu_send_msg and mt76u_mcu_send_msg routines
288d600a8880 mt76: move mt76x2u_mcu_deinit routine in mt76-usb module
851ab66e293c mt76: add multiple regs read support to usb_mcu layer
795dbf0fd20c mt76x0: use mt76u_init for bus initialization
e9fa647a0ad3 mt76x0: remove mt76x0_vendor_reset routine
72750efddba9 mt76x0: remove mt76x0_vendor_single_wr routine
84740d5dc66e mt76x0: remove mt76x0_mcu_msg_alloc routine
ad27c4ae0ba7 mt76x0: use shared mt76 usb mcu completion
73d411e2d499 mt76x0: remove mt76x0_complete_urb routine
172222cff066 mt76x0: remove mt76x0_vendor_request routine
876d3d02ee31 mt76x0: remove unused mt76x0_wait_asic_ready routine
6f4796b7063e mt76x0: use mt76u_mcu_send_msg utility routine to send fw cmds
0e3612e06be4 mt76x0: remove unused mt76x0_mcu structure
a0b65ca60ec7 mt76x0: use mt76u_mcu_fw_send_data for fw uploading
01b302cd5874 mt76x0: remove unused routines for usb_buff alloc/free

-- 
https://patchwork.kernel.org/patch/10576059/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
