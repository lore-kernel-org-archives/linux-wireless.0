Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:37039 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbdL0KH7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Dec 2017 05:07:59 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/10] ath10k: Add hw param for 64-bit address support
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1513846859-23639-2-git-send-email-govinds@qti.qualcomm.com>
References: <1513846859-23639-2-git-send-email-govinds@qti.qualcomm.com>
To: Govind Singh <govinds@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Rakesh Pillai" <pillair@qti.qualcomm.com>,
        Govind Singh <govinds@qti.qualcomm.com>
Message-ID: <b76f2a5377bf41aaa386645b432a2177@euamsexm01a.eu.qualcomm.com> (sfid-20171227_110804_106620_CE78648E)
Date: Wed, 27 Dec 2017 11:07:52 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@qti.qualcomm.com> wrote:

> WCN3990 target supports 37-bit addressing mode. In order
> to accommodate extended address support, add hw param to
> indicate if the target supports addressing above 32-bits.
> 
> Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
> Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

10 patches applied to ath-next branch of ath.git, thanks.

f13cc6bd68ba ath10k: Add hw param for 64-bit address support
e3def6f7ddf8 ath10k: Update rx descriptor for WCN3990 target
3b0b55b19d1d ath10k: Add support for 64 bit HTT in-order indication msg
9abe68535ad8 ath10k: Add support for 64 bit htt rx ring cfg
71ad70961093 ath10k: Add support for 64 bit HTT frag descriptor
e62ee5c381c5 ath10k: Add support for htt_data_tx_desc_64 descriptor
bb8d0d15fc6a ath10k: Add hw param for rx ring size support
a91a626baa15 ath10k: Add paddrs_ring_64 support for 64bit target
5dac5f3772f6 ath10k: Use dma_addr_t for ce buffers to support 64bit target
2a1e1ad3fd37 ath10k: Add support for 64 bit ce descriptor

-- 
https://patchwork.kernel.org/patch/10127165/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
