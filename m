Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63148 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2LBWjY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 17:39:24 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so824829wey.19
        for <linux-wireless@vger.kernel.org>; Sun, 02 Dec 2012 14:39:22 -0800 (PST)
References: <1354465442-1028-1-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1354465442-1028-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <E88F907A-CE03-47C3-9615-AEBD93C8DC38@gmail.com> (sfid-20121202_233931_479557_E7593792)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Gabor Juhos <juhosg@openwrt.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: rt2800lib: remove trailing semicolons from RFCSR3_* defines
Date: Sun, 2 Dec 2012 22:31:23 +0000
To: Gabor Juhos <juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 2 dec. 2012, at 16:24, Gabor Juhos <juhosg@openwrt.org> wrote:

> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Ouch, that could have led to some nasty bugs. Thanks for spotting this and sending the patch.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> drivers/net/wireless/rt2x00/rt2800.h |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index 6d67c3e..1157b06 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -1993,8 +1993,8 @@ struct mac_iveiv_entry {
>  */
> #define RFCSR3_K            FIELD8(0x0f)
> /* Bits [7-4] for RF3320 (RT3370/RT3390), on other chipsets reserved */
> -#define RFCSR3_PA1_BIAS_CCK        FIELD8(0x70);
> -#define RFCSR3_PA2_CASCODE_BIAS_CCKK    FIELD8(0x80);
> +#define RFCSR3_PA1_BIAS_CCK        FIELD8(0x70)
> +#define RFCSR3_PA2_CASCODE_BIAS_CCKK    FIELD8(0x80)
> 
> /*
>  * FRCSR 5:
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
