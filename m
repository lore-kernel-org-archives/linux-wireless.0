Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53276 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab1C0JQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Mar 2011 05:16:18 -0400
Received: by qyk7 with SMTP id 7so550032qyk.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Mar 2011 02:16:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1301184953-18436-1-git-send-email-xose.vazquez@gmail.com>
References: <1301184953-18436-1-git-send-email-xose.vazquez@gmail.com>
Date: Sun, 27 Mar 2011 11:16:17 +0200
Message-ID: <AANLkTinvSaJC_0NsXAgDZrOmz4CpJQVS-Sj7ZJk-skc5@mail.gmail.com>
Subject: Re: [PATCH] wireless: rt2x00: rt{2500,73}usb.c fix duplicate ids
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, gwingerde@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> based on the Ralink drivers:
>
> W = Windows_ralink_driver
> L = Linux_ralink_driver
>
> USB_IDs         W_73  W_2500 L_73  L_2500
> =============   ====  ====== ====  ======
> 0x050d,0x7050   -     -      -     YES
> 0x050d,0x705a   -     -      YES   -
> 0x1371,0x9022   -     YES    YES   -
> 0x148f,0x2573   YES   -      YES   -
>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
