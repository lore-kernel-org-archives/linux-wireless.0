Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41205 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbcAYNex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 08:34:53 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, martin.blumenstingl@googlemail.com
Subject: Re: [PATCH] ath9k_hw: ignore eeprom magic mismatch on flash based devices
References: <1453390448-87417-1-git-send-email-nbd@openwrt.org>
Date: Mon, 25 Jan 2016 15:34:47 +0200
In-Reply-To: <1453390448-87417-1-git-send-email-nbd@openwrt.org> (Felix
	Fietkau's message of "Thu, 21 Jan 2016 16:34:08 +0100")
Message-ID: <87h9i1sryg.fsf@kamboji.qca.qualcomm.com> (sfid-20160125_143456_858466_51ECE267)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> Many AR913x based devices (maybe others too) do not have a valid EEPROM
> magic in their calibration data partition.
>
> Fixes: 6fa658fd5ab2 ("ath9k: Simplify and fix eeprom endianness swapping")
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Applied to ath-current in ath.git, thanks.

-- 
Kalle Valo
