Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38547 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933138AbbCPQOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 12:14:22 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [PATCHv2,
 1/9] mwifiex: lock main process till reinitialization of vif is over
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426248479-28451-2-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <liuzy@marvell.com>, <crlo@marvell.com>,
	<pchen@marvell.com>, <szli@marvell.com>, <nishants@marvell.com>,
	Avinash Patil <patila@marvell.com>
Message-Id: <20150316161421.C29ED140007@smtp.codeaurora.org> (sfid-20150316_171425_971415_57F2D014)
Date: Mon, 16 Mar 2015 16:14:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> A crash was detected while changing virtual interface type is in
> progress. This was tracked to race condition in accessing bss_priority
> table while change is in progress. This patch ensures that main_process
> and rx_process works are locked while we change virtual interface.
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>

Thanks, 9 patches applied to wireless-drivers-next.git:

a9adbcb3355c mwifiex: lock main process till reinitialization of vif is over
621599446dae mwifiex: rename alloc_rx_buf to alloc_dma_aligned_buf
ea44f4d04c93 mwifiex: enhance SD8897 MP aggregation limits
b2713f67f7a4 mwifiex: avoid queue_work while work is ongoing
39df5e8233bf mwifiex: get rid of BA setup helper functions
690e792cb9d7 mwifiex: remove_bss_prio_lock
e35000ead491 mwifiex: preprocess packets from TX queue
92263a841b15 mwifiex: add SDIO rx single port aggregation
960d6d08e395 mwifiex: delay skb allocation for RX until cmd53 over

Kalle Valo
