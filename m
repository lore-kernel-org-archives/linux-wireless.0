Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:25904 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbbK3PGv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 10:06:51 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <poh@codeaurora.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: stop abusing GFP_DMA
References: <1448361412-22589-1-git-send-email-nbd@openwrt.org>
Date: Mon, 30 Nov 2015 17:06:38 +0200
In-Reply-To: <1448361412-22589-1-git-send-email-nbd@openwrt.org> (Felix
	Fietkau's message of "Tue, 24 Nov 2015 11:36:52 +0100")
Message-ID: <87two3il1d.fsf@kamboji.qca.qualcomm.com> (sfid-20151130_160653_989466_ADA6EC57)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> Allocations from the DMA zone were originally added for legacy ISA
> stuff, or PCI devices that have specific limitations in their DMA
> addressing capabilities. It has no place in ath10k, which can do
> full 32-bit DMA.
>
> Fixes memory allocation errors on some platforms.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Applied, thanks.

-- 
Kalle Valo
