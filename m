Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33166 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaANNUY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 08:20:24 -0500
Received: by mail-ie0-f170.google.com with SMTP id tq11so327844ieb.15
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 05:20:23 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 14 Jan 2014 15:20:23 +0200
Message-ID: <CAC0tyxN8Ma4mi9YoTN8MkC_Dc6SKpdGHz1dCpRjLZtTZHe22TA@mail.gmail.com> (sfid-20140114_142028_128956_0664EAFB)
Subject: AR6103 firmware loading failed
From: =?ISO-8859-1?Q?M=E5rten_Wikman?= <marten.wikman@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath6kl-devel@qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm trying to bring up a SDIO card that has a AR6103 wifi module on it
. I have copied AR6003 from linux-firmware to /lib/firmware in my
rootfs and renamed bdata.SD31.bin to bdata.bin but I can't get it to
work.

This are the error messages I get when I plug the card into my SDIO slot.
[  368.966731] mmc0: queuing unknown CIS tuple 0x01 (3 bytes)
[  368.986778] mmc0: queuing unknown CIS tuple 0x1a (5 bytes)
[  368.997861] mmc0: queuing unknown CIS tuple 0x1b (8 bytes)
[  369.005315] mmc0: queuing unknown CIS tuple 0x14 (0 bytes)
[  369.020520] mmc0: queuing unknown CIS tuple 0x80 (1 bytes)
[  369.026470] mmc0: queuing unknown CIS tuple 0x81 (1 bytes)
[  369.034130] mmc0: queuing unknown CIS tuple 0x82 (1 bytes)
[  369.041074] mmc0: new high speed SDIO card at address 0001
[  370.601696] ath6kl_sdio mmc0:0001:1: Direct firmware load failed
with error -2
[  370.608987] ath6kl_sdio mmc0:0001:1: Falling back to user helper
[  400.715813] ath6kl_sdio mmc0:0001:1: Direct firmware load failed
with error -2
[  400.723368] ath6kl_sdio mmc0:0001:1: Falling back to user helper
[  400.911561] ath6kl: temporary war to avoid sdio crc error
[  401.446677] ath6kl: Failed to claim sdio irq: -12
[  401.453973] ath6kl: wmi is not ready or wait was interrupted: -512
[  401.463383] ath6kl: Failed to start hardware: -5
[  401.472617] ath6kl: Failed to init ath6kl core
[  401.478326] ath6kl_sdio: probe of mmc0:0001:1 failed with error -5

Best regards,
Marten Wikman
