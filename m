Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56443 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752221AbcICJ7N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 05:59:13 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: bcma: support BCM53573 series of wireless SoCs
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1469471640-15656-1-git-send-email-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org (open list:BROADCOM SPECIFIC AMBA DRIVER
        (BCMA)), linux-kernel@vger.kernel.org (open list)
Message-Id: <20160903095912.7B31061AC4@smtp.codeaurora.org> (sfid-20160903_115935_326206_05F83D53)
Date: Sat,  3 Sep 2016 09:59:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> BCM53573 seems to be the first series of Northstar family with wireless
> on the chip. The base models are BCM53573-s (A0, A1) and there is also
> BCM47189B0 which seems to be some small modification.
> 
> The only problem with these chipsets seems to be watchdog. It's totally
> unavailable on 53573A0 / 53573A1 and preferable PMU watchdog is broken
> on 53573B0 / 53573B1.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

3f37ec79dd21 bcma: support BCM53573 series of wireless SoCs

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9246319/
