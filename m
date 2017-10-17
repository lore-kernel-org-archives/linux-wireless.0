Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39258 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758823AbdJQOXD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 10:23:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: bcma: use bcma_debug and pr_cont in MIPS driver
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171016125432.11655-1-zajec5@gmail.com>
References: <20171016125432.11655-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20171017142303.03B9C6079D@smtp.codeaurora.org> (sfid-20171017_162306_869795_F9C826A0)
Date: Tue, 17 Oct 2017 14:23:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Using bcma_debug gives a device-specific prefix for messages and pr_cont
> is a common helper for continuing a line.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-By: Hauke Mehrtens <hauke@hauke-m.de>

Patch applied to wireless-drivers-next.git, thanks.

66cc04424960 bcma: use bcma_debug and pr_cont in MIPS driver

-- 
https://patchwork.kernel.org/patch/10008245/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
