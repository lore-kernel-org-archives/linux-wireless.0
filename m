Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52493 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbbEINnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 09:43:00 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: wl18xx: wlan_irq: support platform dependent interrupt types
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1430319003-13123-1-git-send-email-eyalr@ti.com>
To: Eyal Reizer <eyalreizer@gmail.com>
Cc: linux-wireless@vger.kernel.org, Eyal Reizer <eyalr@ti.com>
Message-Id: <20150509134259.8FBE514010A@smtp.codeaurora.org> (sfid-20150509_154303_886417_17F0F306)
Date: Sat,  9 May 2015 13:42:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> * Interrupt request need to happen when the wilink chip is powered on and
>   driving the wlan_irq line. This avoids spurious interrupt issues that
>   are a result of different external pulls configuration on different
>   platforms
> * Allow working with wl18xx level-low and falling edge irqs by configuring
>   wl18xx to invert the device interrupt
> 
> Signed-off-by: Eyal Reizer <eyalr@ti.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
