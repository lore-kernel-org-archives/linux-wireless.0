Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45943 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbbFHIkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 04:40:47 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: fix DMA stop sequence for AR9003+
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1433234312-78045-1-git-send-email-nbd@openwrt.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20150608084047.51BA51406FE@smtp.codeaurora.org> (sfid-20150608_104051_119099_686AD9F0)
Date: Mon,  8 Jun 2015 08:40:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> AR93xx and newer needs to stop rx before tx to avoid getting the DMA
> engine or MAC into a stuck state.
> This should reduce/fix the occurence of "Failed to stop Tx DMA" logspam.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
