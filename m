Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42918 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2LBQ0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 11:26:37 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so1095186vcd.19
        for <linux-wireless@vger.kernel.org>; Sun, 02 Dec 2012 08:26:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354465442-1028-1-git-send-email-juhosg@openwrt.org>
References: <1354465442-1028-1-git-send-email-juhosg@openwrt.org>
Date: Sun, 2 Dec 2012 17:26:36 +0100
Message-ID: <CAOZOX0VN4fs1uWQOJPkJ1CXvkrgEHDCcKq0rPRTsMCBCd8u7kw@mail.gmail.com> (sfid-20121202_172641_535266_032A0AF6)
Subject: Re: [PATCH] rt2x00: rt2800lib: remove trailing semicolons from
 RFCSR3_* defines
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 2, 2012 at 5:24 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index 6d67c3e..1157b06 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -1993,8 +1993,8 @@ struct mac_iveiv_entry {
>   */
>  #define RFCSR3_K                       FIELD8(0x0f)
>  /* Bits [7-4] for RF3320 (RT3370/RT3390), on other chipsets reserved */
> -#define RFCSR3_PA1_BIAS_CCK            FIELD8(0x70);
> -#define RFCSR3_PA2_CASCODE_BIAS_CCKK   FIELD8(0x80);
> +#define RFCSR3_PA1_BIAS_CCK            FIELD8(0x70)
> +#define RFCSR3_PA2_CASCODE_BIAS_CCKK   FIELD8(0x80)
>
>  /*
>   * FRCSR 5:
> --
> 1.7.10
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
