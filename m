Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:60383 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaAWRWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 12:22:05 -0500
Received: by mail-oa0-f43.google.com with SMTP id h16so2471290oag.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 09:22:03 -0800 (PST)
Message-ID: <52E14FB6.7080504@lwfinger.net> (sfid-20140123_182209_402914_0F063817)
Date: Thu, 23 Jan 2014 11:21:58 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Ben Hutchings <ben@decadent.org.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: [FIRMWARE PATCH] rtlwifi: Add firmware for rtl8821ae
References: <20140123163807.GA16360@kroah.com>
In-Reply-To: <20140123163807.GA16360@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2014 10:38 AM, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This firmware is for a driver for the Realtek 8821AE PCI WIFI device.
> It came from a tarball from Realtek named
> wifi_driver_8821ae_0018.1129.2013.tar.gz and is allowed to be
> distributed under the LICENCE.rtlwifi_firmware.txt license.
>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   WHENCE                  |   9 +++++++++
>   rtlwifi/rtl8821aefw.bin | Bin 0 -> 29198 bytes
>   2 files changed, 9 insertions(+)
>   create mode 100644 rtlwifi/rtl8821aefw.bin
>
> diff --git a/WHENCE b/WHENCE
> index 00767b179a68..16ab53e2ba75 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1962,6 +1962,15 @@ Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
>
>   --------------------------------------------------------------------------
>
> +Driver: rtl8821ae - Realtek 802.11n WLAN driver for RTL8821AE
> +
> +Info: Taken from Realtek version wifi_driver_8821ae_0018.1129.2013.tar.gz
> +File: rtlwifi/rtl8821ae.bin
> +
> +Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
> +
> +--------------------------------------------------------------------------

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks for submitting this.

Larry

