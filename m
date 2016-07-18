Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40461 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbcGRTiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:38:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [FIX,4.6+] bcma: add PCI ID for Foxconn's BCM43142 device
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1468270896-2988-1-git-send-email-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Stable <stable@vger.kernel.org>,
	linux-wireless@vger.kernel.org (open list:BROADCOM SPECIFIC AMBA DRIVER
	(BCMA)), linux-kernel@vger.kernel.org (open list)
Message-Id: <20160718193853.9210D6034D@smtp.codeaurora.org> (sfid-20160718_213913_142860_9DB504EF)
Date: Mon, 18 Jul 2016 19:38:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> After discovering there are 2 very different 14e4:4365 PCI devices we
> made ID tables less generic. Back then we believed there are only 2 such
> devices:
> 1) 14e4:4365 1028:0016 with SoftMAC BCM43142 chipset
> 2) 14e4:4365 14e4:4365 with FullMAC BCM4366 chipset
> 
> >From the recent report it appears there is also 14e4:4365 105b:e092
> which should be claimed by bcma. Add back support for it.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=121881
> Fixes: 515b399c9a20 ("bcma: claim only 14e4:4365 PCI Dell card with SoftMAC BCM43142")
> Reported-by: Igor Mammedov <imammedo@redhat.com>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Cc: Stable <stable@vger.kernel.org> [4.6+]
> Tested-by: Igor Mammedov <imammedo@redhat.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

1bea0512c339 bcma: add PCI ID for Foxconn's BCM43142 device

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9224231/

