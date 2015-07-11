Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51208 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbGKQ7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2015 12:59:43 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k_hw: fix device ID check for AR956x
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1434908866-99327-1-git-send-email-nbd@openwrt.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20150711165942.E077913F887@smtp.codeaurora.org> (sfid-20150711_185958_215113_5913BBED)
Date: Sat, 11 Jul 2015 16:59:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Because of the missing return, the macVersion value was being
> overwritten with an invalid register read
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, applied to wireless-drivers.git.

Kalle Valo
