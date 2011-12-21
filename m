Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63449 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab1LUESA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 23:18:00 -0500
Date: Wed, 21 Dec 2011 02:18:35 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] Bluetooth: btusb: fix bInterval for high/super speed
 isochronous endpoints
Message-ID: <20111221041835.GB2729@joana> (sfid-20111221_051806_832681_3F3A1B44)
References: <1324433940-16838-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1324433940-16838-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

* Bing Zhao <bzhao@marvell.com> [2011-12-20 18:19:00 -0800]:

> For high-speed/super-speed isochronous endpoints, the bInterval
> value is used as exponent, 2^(bInterval-1). Luckily we have
> usb_fill_int_urb() function that handles it correctly. So we just
> call this function to fill in the RX URB.
> 
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/bluetooth/btusb.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)

Applied, thanks.

	Gustavo
