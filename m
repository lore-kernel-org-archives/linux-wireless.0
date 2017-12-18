Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37824 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758022AbdLRNnQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 08:43:16 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [09/14] mt76x2: remove MAC address limitation for multi-vif setups
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171214153918.43774-10-nbd@nbd.name>
References: <20171214153918.43774-10-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20171218134316.765C86070B@smtp.codeaurora.org> (sfid-20171218_144320_905746_B406459E)
Date: Mon, 18 Dec 2017 13:43:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> The hardware has a separate set of registers to configure a
> per-interface MAC address.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Dropped per Felix request

3 patches set to Changes Requested.

10112557 [09/14] mt76x2: remove MAC address limitation for multi-vif setups
10112559 [10/14] mt76x2: clean up MAC/BSSID address initialization
10112571 [11/14] mt76x2: drop wiphy->addresses

-- 
https://patchwork.kernel.org/patch/10112557/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
