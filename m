Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58472 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752189AbeDXR3I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:29:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: fix tssi initialization for 5GHz band
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <53d9322f1b5cafb832163b8ef93118aecc1ef3f1.1522766285.git.lorenzo.bianconi@redhat.com>
References: <53d9322f1b5cafb832163b8ef93118aecc1ef3f1.1522766285.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180424172907.523396085F@smtp.codeaurora.org> (sfid-20180424_192912_010586_1C76FA96)
Date: Tue, 24 Apr 2018 17:29:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Fix mcu initial configuration for tssi calibration on 5GHz band
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers-next.git, thanks.

2cb161094ef9 mt76x2: fix tssi initialization for 5GHz band

-- 
https://patchwork.kernel.org/patch/10321335/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
