Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36750 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932991Ab0D3Ud6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 16:33:58 -0400
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/11] ath9k_htc: Use USB reboot
References: <19409.10472.450708.915467@gargle.gargle.HOWL>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 29 Apr 2010 19:14:12 +0300
In-Reply-To: <19409.10472.450708.915467@gargle.gargle.HOWL> (Sujith's message of "Fri\, 23 Apr 2010 10\:28\:16 +0530")
Message-ID: <87zl0mjkx7.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith <Sujith.Manoharan@atheros.com> writes:

> So, apparently there is a USB reboot command
> that the target accepts. Using this instead of
> usb_reset_device() fixes the issue of "descriptor read error"
> that pops up on repeated load/unload.

[...]

> +static void ath9k_hif_usb_reboot(struct usb_device *udev)
> +{
> +	u32 reboot_cmd = 0xffffffff;

A define for the actual command value would be nice here.

-- 
Kalle Valo
