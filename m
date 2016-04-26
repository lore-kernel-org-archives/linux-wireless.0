Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46047 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbcDZIqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 04:46:39 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mt76: add driver code for MT76x2e
References: <1457039737-61262-1-git-send-email-nbd@openwrt.org>
	<1457039737-61262-2-git-send-email-nbd@openwrt.org>
Date: Tue, 26 Apr 2016 11:46:35 +0300
In-Reply-To: <1457039737-61262-2-git-send-email-nbd@openwrt.org> (Felix
	Fietkau's message of "Thu, 3 Mar 2016 22:15:37 +0100")
Message-ID: <87lh40zris.fsf@kamboji.qca.qualcomm.com> (sfid-20160426_104644_776626_B01961E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> This is a 2x2 PCIe 802.11ac chipset by MediaTek
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

A little more overview would be nice, for example what works and what
doesn't?

What about the firmware images? Will they be available from
linux-firmware.git?

Otherwise looks really good.

> +MODULE_LICENSE("GPL");

"GPL v2"?

-- 
Kalle Valo
