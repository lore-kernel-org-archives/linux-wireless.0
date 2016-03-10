Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49527 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbcCJOqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 09:46:49 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 107/113] rtl8xxxu: Use define for REG_PWR_DATA bits
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
	<1456783551-28315-108-git-send-email-Jes.Sorensen@redhat.com>
Date: Thu, 10 Mar 2016 16:46:45 +0200
In-Reply-To: <1456783551-28315-108-git-send-email-Jes.Sorensen@redhat.com>
	(Jes Sorensen's message of "Mon, 29 Feb 2016 17:05:45 -0500")
Message-ID: <87mvq6jsq2.fsf@purkki.adurom.net> (sfid-20160310_154653_015097_B213F82F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes.Sorensen@redhat.com writes:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Use the bit define rather than hard code the value for REG_PWR_DATA bits.
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

[...]

> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
> @@ -135,7 +135,7 @@
>  #define  EFUSE_ACCESS_DISABLE		0x00	/* RTL8723 only */
>  
>  #define REG_PWR_DATA			0x0038
> -#define PWR_DATA_EEPRPAD_RFE_CTRL_EN	BIT(11)
> +#define  PWR_DATA_EEPRPAD_RFE_CTRL_EN	BIT(11)

Again the two spaces. Is your editor adding them automatically or what?

-- 
Kalle Valo
