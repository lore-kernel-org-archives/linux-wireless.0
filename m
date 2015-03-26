Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:35313 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbbCZPbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 11:31:48 -0400
Message-ID: <55142660.9060004@lwfinger.net> (sfid-20150326_163205_547785_37DFC2CA)
Date: Thu, 26 Mar 2015 10:31:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>, linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH V2] rtlwifi: rtl8192cu: Add new device ID
References: <1427332566-9398-1-git-send-email-marex@denx.de>
In-Reply-To: <1427332566-9398-1-git-send-email-marex@denx.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/25/2015 08:16 PM, Marek Vasut wrote:
> Add new ID for ASUS N10 WiFi dongle.
>
> Signed-off-by: Marek Vasut <marex@denx.de>
> Tested-by: Marek Vasut <marex@denx.de>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: John W. Linville <linville@tuxdriver.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 1 +
>   1 file changed, 1 insertion(+)
>
> V2: - Move the ID into correct position
>      - Add my Tested-by to indicate this change was tested on real HW
>      - Drop the confusing USB device listing from the diffstat section
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> index 90a714c..252eb76 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> @@ -321,6 +321,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
>   	{RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
>   	{RTL_USB_DEVICE(0x07b8, 0x8189, rtl92cu_hal_cfg)}, /*Funai - Abocom*/
>   	{RTL_USB_DEVICE(0x0846, 0x9041, rtl92cu_hal_cfg)}, /*NetGear WNA1000M*/
> +	{RTL_USB_DEVICE(0x0b05, 0x17ba, rtl92cu_hal_cfg)}, /*ASUS-Edimax*/
>   	{RTL_USB_DEVICE(0x0bda, 0x5088, rtl92cu_hal_cfg)}, /*Thinkware-CC&C*/
>   	{RTL_USB_DEVICE(0x0df6, 0x0052, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
>   	{RTL_USB_DEVICE(0x0df6, 0x005c, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
>

