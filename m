Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43953 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752658AbcLGOMN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 09:12:13 -0500
Subject: Re: [v3,3/3] mt76: add driver code for MT76x2e
To: Kalle Valo <kvalo@codeaurora.org>
References: <20160905095128.80560-4-nbd@nbd.name>
 <20161004163457.08D6861A06@smtp.codeaurora.org>
Cc: linux-wireless@vger.kernel.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <4ca18331-eef3-ee12-2bb0-a11d9c15b96b@nbd.name> (sfid-20161207_151221_457905_0BB7BB7A)
Date: Wed, 7 Dec 2016 15:11:34 +0100
MIME-Version: 1.0
In-Reply-To: <20161004163457.08D6861A06@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-10-04 18:34, Kalle Valo wrote:
> Felix Fietkau <nbd@nbd.name> wrote:
>> From: Felix Fietkau <nbd@openwrt.org>
>> 
>> This is a 2x2 PCIe 802.11ac chipset by MediaTek
>> 
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> 
> A summary of what feature work would be nice to have. Also if there's something
> notable which is not working it's good also to mention that.
> 
> I don't know why I didn't see this earlier but this fails to build for me:
> 
> ERROR: "mtd_read" [drivers/net/wireless/mediatek/mt76/mt76.ko] undefined!
> ERROR: "put_mtd_device" [drivers/net/wireless/mediatek/mt76/mt76.ko] undefined!
> ERROR: "get_mtd_device_nm" [drivers/net/wireless/mediatek/mt76/mt76.ko] undefined!
> 
> Dependency to mtd missing?
Will fix the #ifdef in v4.

- Felix
