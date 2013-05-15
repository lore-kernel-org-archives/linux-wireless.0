Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34391 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3EOUXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 16:23:06 -0400
Received: by mail-lb0-f182.google.com with SMTP id r11so2355971lbv.13
        for <linux-wireless@vger.kernel.org>; Wed, 15 May 2013 13:23:04 -0700 (PDT)
Message-ID: <5193EEA8.8030900@cogentembedded.com> (sfid-20130515_222316_623323_EF8F08EE)
Date: Thu, 16 May 2013 00:23:04 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Albert Pool <albertpool@solcon.nl>, netdev@vger.kernel.org
Subject: Re: [PATCH V3] rtlwifi: rtl8192cu: Add new USB ID
References: <1368630196-14704-1-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1368630196-14704-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 05/15/2013 07:03 PM, Larry Finger wrote:

> From: Albert Pool <albertpool@solcon.nl>
>
> This adds the USB ID of the On Networks N300MA, clone of Netgear WNA3100M.
>
> Signed-off-by: Albert Pool <albertpool@solcon.nl>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Reported-by: Ana Rey <Anazul77@hotmail.com>
> ---
>
> John,
>
> Please use this version. V2 still had some whitespace errors that I fixed.
>
> Albert,
>
> Please use scripts/checkpatch.pl to check the patch before you send it.
>
> Thanks,
>
> Larry
> ---
>
>   drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> index 23d640a..18da6de 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> @@ -349,6 +349,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
>   	{RTL_USB_DEVICE(0x07aa, 0x0056, rtl92cu_hal_cfg)}, /*ATKK-Gemtek*/
>   	{RTL_USB_DEVICE(0x07b8, 0x8178, rtl92cu_hal_cfg)}, /*Funai -Abocom*/
>   	{RTL_USB_DEVICE(0x0846, 0x9021, rtl92cu_hal_cfg)}, /*Netgear-Sercomm*/
> +	{RTL_USB_DEVICE(0x0846, 0xf001, rtl92cu_hal_cfg)}, /*On Netwrks N300MA*/

    "Networks", perhaps? Or does it hit 80 columns limit this way?

WBR, Sergei

