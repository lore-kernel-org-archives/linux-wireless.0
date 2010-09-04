Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44539 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab0IDXWT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Sep 2010 19:22:19 -0400
Subject: Re: [PATCH] ath9k_htc: Update AR7010 firmwares
From: David Woodhouse <dwmw2@infradead.org>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1283530280-6263-1-git-send-email-rmanoharan@atheros.com>
References: <1283530280-6263-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Sep 2010 00:22:10 +0100
Message-ID: <1283642530.15689.2.camel@i7.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-03 at 17:11 +0100, Rajkumar Manoharan wrote:
> AR7010 firmwares are patched to change EP3 & EP4
> from Interrupt to Bulk type.
> 
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> ---
>  ar7010.fw     |  Bin 70608 -> 70624 bytes
>  ar7010_1_1.fw |  Bin 70608 -> 70624 bytes
>  2 files changed, 0 insertions(+), 0 deletions(-) 

Is that a compatible change which will continue to work with old
kernels?

If not, the firmware needs a new filename -- think of it like an soname
on userspace libraries.

-- 
dwmw2

