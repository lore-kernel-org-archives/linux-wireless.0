Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33351 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab3BOUUv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 15:20:51 -0500
Message-ID: <511E9896.9010502@hauke-m.de> (sfid-20130215_212054_963450_ED69394A)
Date: Fri, 15 Feb 2013 21:20:38 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: john@phrozen.org, ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ssb: add gpio_to_irq again
References: <1355275031-19297-1-git-send-email-hauke@hauke-m.de> <1355275031-19297-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1355275031-19297-2-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/2012 02:17 AM, Hauke Mehrtens wrote:
> The old code had support for gpio_to_irq, but the new code did not
> provide this function, but returned -ENXIO all the time. This patch
> adds the missing function.
> 
> arch/mips/bcm47xx/wgt634u.c calls gpio_to_irq() and got the correct irq
> number with the old gpio handling code. With this patch the code in
> wgt634u.c should work again. I do not have a wgt634u to test this.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Please drop these two patches

They will cause merge problems. After I talked to blogic and after that
I send these patches to John Linville for inclusion into the wireless tree.

Hauke
