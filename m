Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33920 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751764AbcJDQpK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 12:45:10 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,3/3] mt76: add driver code for MT76x2e
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160905095128.80560-4-nbd@nbd.name>
References: <20160905095128.80560-4-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20161004164509.4DC5B61AF5@smtp.codeaurora.org> (sfid-20161004_184533_238534_A7B1C4DD)
Date: Tue,  4 Oct 2016 16:45:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:
> From: Felix Fietkau <nbd@openwrt.org>
> 
> This is a 2x2 PCIe 802.11ac chipset by MediaTek
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

I already asked this in v2, but what about firmware images? Will they be
available from linux-firmware.git?

-- 
https://patchwork.kernel.org/patch/9313311/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
