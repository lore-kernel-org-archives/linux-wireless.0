Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60492 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbbGUN5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 09:57:10 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: make DMA stop related messages debug-only
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1435837229-94571-1-git-send-email-nbd@openwrt.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20150721135709.7F6CF141377@smtp.codeaurora.org> (sfid-20150721_155715_261202_21045AA8)
Date: Tue, 21 Jul 2015 13:57:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> A long time ago, ath9k had issues during reset where the DMA engine
> would stay active and could potentially corrupt memory.
> To debug those issues, the driver would print warnings whenever they
> occur.
> 
> Nowadays, these issues are gone and the primary cause of these messages
> is if the MAC is stuck during reset or busy processing a long
> transmission. This is fairly harmless, yet these messages continue to
> worry users.
> 
> To reduce the number of bogus bug reports, turn these messages into
> debug messages and count their occurence in the "reset" debugfs file.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
