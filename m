Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44703 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab2FMKNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 06:13:53 -0400
Received: by eeit10 with SMTP id t10so126292eei.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 03:13:51 -0700 (PDT)
Message-ID: <4FD867DB.9070806@gmail.com> (sfid-20120613_121356_629722_A851EF74)
Date: Wed, 13 Jun 2012 12:13:47 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Woody.Hung@mediatek.com
Subject: Re: [PATCH] rt2x00 : RT3290 chip support v4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Woody Hung wrote:

> --- a/drivers/net/wireless/rt2x00/rt2800pci.h
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.h
> @@ -47,6 +47,7 @@
>   * 8051 firmware image.
>   */
>  #define FIRMWARE_RT2860			"rt2860.bin"
> +#define FIRMWARE_RT3290			"rt3290.bin"

There is no rt3290 fw in linux-firmware [1]
Please, send it ASAP.

[1] http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git
