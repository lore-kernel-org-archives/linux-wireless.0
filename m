Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47791 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3F1VmM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 17:42:12 -0400
Received: by mail-wi0-f171.google.com with SMTP id hj3so1267814wib.10
        for <linux-wireless@vger.kernel.org>; Fri, 28 Jun 2013 14:42:10 -0700 (PDT)
Message-ID: <51CE0330.7090007@gmail.com> (sfid-20130628_234215_226345_51CFADD6)
Date: Fri, 28 Jun 2013 23:42:08 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH 02/19] rt2x00: rt2800lib: add RFCSR register initialization
 for RT3593
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:

> Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
> driver.

There is a more recent version: DPO_RT5572_LinuxSTA_2.6.1.3_20121022

> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 32ecd1a..0041b2c 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> [...]
> +	/* Initialize default register values */
> +	rt2800_rfcsr_write(rt2x00dev, 1, 0x03);
> +	rt2800_rfcsr_write(rt2x00dev, 3, 0x80);

from ./20120911_RT3573_Linux_STA_v2.5.0.0_Rev1_DPO/chips/rt3593.c

{RF_R02,                0x80}

but it was deleted in ./DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rt3593.c

Was it deliberate ? or a mistake ??
