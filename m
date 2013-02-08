Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:41295 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753379Ab3BHSh7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 13:37:59 -0500
Message-ID: <1360348677.2268.7.camel@joe-AO722> (sfid-20130208_193804_063264_48458FBD)
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Add new USB ID
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Date: Fri, 08 Feb 2013 10:37:57 -0800
In-Reply-To: <1360348098-8687-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1360348098-8687-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 12:28 -0600, Larry Finger wrote:
> A new model of the RTL8188CUS has appeared.
[]
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> index 577c0dc..a73a17b 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> @@ -285,6 +285,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
>  	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817f, rtl92cu_hal_cfg)},
>  	/* RTL8188CUS-VL */
>  	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x818a, rtl92cu_hal_cfg)},
> +	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x819a, rtl92cu_hal_cfg)},
>  	/* 8188 Combo for BC4 */
>  	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8754, rtl92cu_hal_cfg)},

One day would you please do a s/_VENDOR_/_VENDOR_/g
 



