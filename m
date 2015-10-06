Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20726 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbbJFMFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 08:05:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: use pre-allocated DMA buffer in Tx
References: <1443117270-16790-1-git-send-email-poh@qca.qualcomm.com>
Date: Tue, 6 Oct 2015 15:05:42 +0300
In-Reply-To: <1443117270-16790-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Thu, 24 Sep 2015 10:54:30 -0700")
Message-ID: <874mi42odl.fsf@kamboji.qca.qualcomm.com> (sfid-20151006_140554_621686_E0193A7E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> ath10k driver is using dma_pool_alloc per packet and dma_pool_free
> in coresponding at Tx completion.
> Use of pre-allocated DMA buffer in Tx will improve saving CPU resource
> by 5% while it consumes about 56KB memory more as trade off.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
