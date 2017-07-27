Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55428 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdG0K7W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 06:59:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: bcma: gpio: Correct number of GPIOs for BCM53573
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170630190257.15016-1-f.fainelli@gmail.com>
References: <20170630190257.15016-1-f.fainelli@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org (open list:BROADCOM SPECIFIC AMBA DRIVER
        (BCMA))
Message-Id: <20170727105922.4E9B7607A3@smtp.codeaurora.org> (sfid-20170727_125936_805462_D19704B5)
Date: Thu, 27 Jul 2017 10:59:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Florian Fainelli <f.fainelli@gmail.com> wrote:

> Broadcom BCM53573 SoCs actually have 32 GPIOs, and not 16.
> 
> Fixes: 3f37ec79dd21 ("bcma: support BCM53573 series of wireless SoCs")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

459c35148ef6 bcma: gpio: Correct number of GPIOs for BCM53573

-- 
https://patchwork.kernel.org/patch/9820259/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
