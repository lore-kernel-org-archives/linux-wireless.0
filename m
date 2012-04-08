Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55949 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab2DHSr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2012 14:47:28 -0400
Received: by iagz16 with SMTP id z16so5078008iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Apr 2012 11:47:27 -0700 (PDT)
Message-ID: <4F81DD3C.5000102@lwfinger.net> (sfid-20120408_204801_278420_9282A937)
Date: Sun, 08 Apr 2012 13:47:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rtlwifi: support for Belkin Surf N300 XR
References: <CAA2SeNKqQQehes3uG3viOLRavcti0A2HbxNC1X26-bptzXyU+w@mail.gmail.com>
In-Reply-To: <CAA2SeNKqQQehes3uG3viOLRavcti0A2HbxNC1X26-bptzXyU+w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2012 01:12 PM, Lorenzo Bianconi wrote:
> Added support for Belkin Surf N300 XR wireless usb adapter to rtlwifi driver
>
> Signed-off-by: Lorenzo Bianconi<lorenzo.bianconi83@gmail.com>
> ---
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> @@ -338,6 +338,7 @@
>   	{RTL_USB_DEVICE(0x2019, 0x1201, rtl92cu_hal_cfg)}, /*Planex-Vencer*/
>
>   	/****** 8192CU ********/
> +	{RTL_USB_DEVICE(0x050d, 0x1004, rtl92cu_hal_cfg)}, /*Belcom-SurfN300*/
>   	{RTL_USB_DEVICE(0x050d, 0x2102, rtl92cu_hal_cfg)}, /*Belcom-Sercomm*/
>   	{RTL_USB_DEVICE(0x050d, 0x2103, rtl92cu_hal_cfg)}, /*Belcom-Edimax*/
>   	{RTL_USB_DEVICE(0x0586, 0x341f, rtl92cu_hal_cfg)}, /*Zyxel -Abocom*/

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

