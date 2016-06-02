Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43194 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbcFBO46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 10:56:58 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/5] ath10k: fix operating irq mode for ahb device
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160527144559.4053-1-rmanohar@qti.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>,
	<rmanohar@codeaurora.org>
Message-ID: <cb83c96b3c154a438b0c7e90372d2984@euamsexm01a.eu.qualcomm.com> (sfid-20160602_165701_534926_31ADF67B)
Date: Thu, 2 Jun 2016 16:56:51 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> Earlier when operating irq mode is legacy, interrupts are disabled
> and re-enabled based on num_msi_intrs. commit cfe9011a05a8 ("ath10k:
> remove MSI range support") replaced num_msi_intrs by oper_irq_mode.
> Since oper_irq_mode is not initialized for ahb devices (i.e qca4019),
> device boot up is failed during probe.
> 
> Fixes: cfe9011a05a8 ("ath10k: remove MSI range support")
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, 5 patches applied to ath.git:

2e550b6d277b ath10k: fix operating irq mode for ahb device
10f8ec64a2a6 ath10k: remove unused phy_mode_to_band
b855de0f5792 ath10k: update module description
64e001f41676 ath10k: add new ATH10K_FW_FEATURE_BTCOEX_PARAM
39136248cf8d ath10k: add pdev param support to enable/disable btcoex

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9138581/

