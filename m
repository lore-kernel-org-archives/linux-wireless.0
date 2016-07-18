Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38960 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbcGRHSY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 03:18:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC] rfkill: Add new ACPI device for Realtek serial BT
References: <1468609696-8828-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Mon, 18 Jul 2016 10:18:19 +0300
In-Reply-To: <1468609696-8828-1-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Fri, 15 Jul 2016 14:08:16 -0500")
Message-ID: <87mvlf9zyc.fsf@purkki.adurom.net> (sfid-20160718_091828_248688_0E819B0F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> The Realtek RTL8723BS chips, which are connected via SDIO, also contain
> a serial Bluetooth device. In order for BT to work, the device must be
> added to the acpi_device_id table.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> I have no idea if this device should be added here, or if the device could
> be added to some structure supplied at device startup. If anyone has any
> suggestions, please let me know.
>
> Thanks,
>
> Larry
> ---
>  net/rfkill/rfkill-gpio.c | 1 +
>  1 file changed, 1 insertion(+)

BTW Johannes maintains rfkill, not me.

-- 
Kalle Valo
