Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56126 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbbCPGfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 02:35:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [4.0] ath9k: disable TPC support again (for now)
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426403224-23795-1-git-send-email-nbd@openwrt.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, lorenzo.bianconi83@gmail.com
Message-Id: <20150316063545.D056E140990@smtp.codeaurora.org> (sfid-20150316_073548_986582_AE239B27)
Date: Mon, 16 Mar 2015 06:35:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> TPC support has been observed to cause some tx power fluctuations on
> some devices with at least AR934x and AR938x chips.
> Disable it for now until the bugs have been found and fixed
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, applied to wireless-drivers.git.

Kalle Valo
