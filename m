Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60738 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754110AbcJDQe5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 12:34:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,3/3] mt76: add driver code for MT76x2e
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160905095128.80560-4-nbd@nbd.name>
References: <20160905095128.80560-4-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20161004163457.08D6861A06@smtp.codeaurora.org> (sfid-20161004_183501_028661_8F6D4B95)
Date: Tue,  4 Oct 2016 16:34:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:
> From: Felix Fietkau <nbd@openwrt.org>
> 
> This is a 2x2 PCIe 802.11ac chipset by MediaTek
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

A summary of what feature work would be nice to have. Also if there's something
notable which is not working it's good also to mention that.

I don't know why I didn't see this earlier but this fails to build for me:

ERROR: "mtd_read" [drivers/net/wireless/mediatek/mt76/mt76.ko] undefined!
ERROR: "put_mtd_device" [drivers/net/wireless/mediatek/mt76/mt76.ko] undefined!
ERROR: "get_mtd_device_nm" [drivers/net/wireless/mediatek/mt76/mt76.ko] undefined!

Dependency to mtd missing?

-- 
https://patchwork.kernel.org/patch/9313311/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
