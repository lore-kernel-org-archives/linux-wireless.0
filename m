Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:45663 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752226AbYKKAI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 19:08:58 -0500
Message-ID: <4918CD14.7080007@lwfinger.net> (sfid-20081111_010901_878990_9CE15B2B)
Date: Mon, 10 Nov 2008 18:08:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ivan Kuten <ivan.kuten@promwad.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187: patch adding Abocom usb id
References: <806c81b61e7dedacfda32d6638548dbb@promwad.com>
In-Reply-To: <806c81b61e7dedacfda32d6638548dbb@promwad.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivan Kuten wrote:
> rtl8187: Add Abocom usb id
> 
> Signed-off-by: Ivan Kuten <ivan.kuten@promwad.com>
> 
> -------------
> 
> --- linux-2.6.28-rc3/drivers/net/wireless/rtl8187_dev.c 2008-11-10
> 18:53:50.000000000 +0200
> +++ linux-2.6.28-rc3.new/drivers/net/wireless/rtl8187_dev.c     2008-11-10
> 19:02:34.000000000 +0200
> @@ -48,6 +48,8 @@
>         {USB_DEVICE(0x03f0, 0xca02), .driver_info = DEVICE_RTL8187},
>         /* Sitecom */
>         {USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
> +       /* Abocom */
> +       {USB_DEVICE(0x13d1, 0xabe6), .driver_info = DEVICE_RTL8187},
>         {}
>  };

ACK.

Larry
