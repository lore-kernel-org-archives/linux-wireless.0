Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38188 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdAaH12 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 02:27:28 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [fix?] bcma: use (get|put)_device when probing/removing device
 driver
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170128133122.12360-1-zajec5@gmail.com>
References: <20170128133122.12360-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20170131072728.040C560A54@smtp.codeaurora.org> (sfid-20170131_082731_918028_763F8B0A)
Date: Tue, 31 Jan 2017 07:27:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This allows tracking device state and e.g. makes devm work as expected.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Cc: Stable <stable@vger.kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

a971df0b9d04 bcma: use (get|put)_device when probing/removing device driver

-- 
https://patchwork.kernel.org/patch/9543283/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
