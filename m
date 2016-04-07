Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52999 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbcDGQuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 12:50:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mt76: add common code shared between multiple chipsets
References: <1457039737-61262-1-git-send-email-nbd@openwrt.org>
Date: Thu, 07 Apr 2016 19:50:03 +0300
In-Reply-To: <1457039737-61262-1-git-send-email-nbd@openwrt.org> (Felix
	Fietkau's message of "Thu, 3 Mar 2016 22:15:36 +0100")
Message-ID: <87lh4p1hz8.fsf@purkki.adurom.net> (sfid-20160407_185013_570094_74964223)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> This will be used by drivers for MT76x2e, MT7603e and MT7628
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

I applied these to the pending branch in wireless-drivers-next so that
kbuild can do it's magic.

-- 
Kalle Valo
