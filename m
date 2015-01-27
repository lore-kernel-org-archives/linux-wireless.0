Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:46736 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973AbbA0SGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 13:06:44 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v4] ath9k and ath9k_htc: rename variable "led_blink"
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1422099243-20321-1-git-send-email-hong@topbug.net>
To: Hong Xu <hong@topbug.net>
Cc: linux-wireless@vger.kernel.org, Hong Xu <hong@topbug.net>
Message-Id: <20150127180644.9EBB9140694@smtp.codeaurora.org> (sfid-20150127_190648_075675_DA4DB7C0)
Date: Tue, 27 Jan 2015 18:06:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> ath9k and ath9k_htc use the variable name "led_blink" to indicate
> whether the module parameter "blink" is on. This name is easy to
> conflict with other variables, and has caused a compiler error found
> by kbuild test bot. The compiler error is as following:
> 
> drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x47c): multiple definition of `led_blink'
> drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x20): first defined here
> 
> Fixes: 3a939a671225 ("ath9k_htc: Add a module parameter to disable blink")
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Hong Xu <hong@topbug.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
