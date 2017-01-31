Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38628 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdAaHaI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 02:30:08 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: bcma: make OF code more generic (not platform_device specific)
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170128221134.9028-1-zajec5@gmail.com>
References: <20170128221134.9028-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20170131073008.436C06072E@smtp.codeaurora.org> (sfid-20170131_083012_221497_BAE0B3FB)
Date: Tue, 31 Jan 2017 07:30:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> OF allows not only specifying platform devices but also describing
> devices on standard buses like PCI or USB. This change will allow
> reading info from DT for bcma buses hosted on PCI cards.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Patch applied to wireless-drivers-next.git, thanks.

b1a4c9a19659 bcma: make OF code more generic (not platform_device specific)

-- 
https://patchwork.kernel.org/patch/9543515/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
