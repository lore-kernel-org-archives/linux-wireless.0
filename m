Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47402 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab0FSNx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jun 2010 09:53:56 -0400
Received: by pvg6 with SMTP id 6so813575pvg.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jun 2010 06:53:56 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 19 Jun 2010 15:53:56 +0200
Message-ID: <AANLkTik5z5SL_JB2-_elmbdyt1rDSxY3IHVEi2V_4uLD@mail.gmail.com>
Subject: Bad performance for libertas on Murata combo.
From: =?UTF-8?Q?Enric_Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Maybe someone can help me ...

I am in the process of enabling WLAN for a target board. It has a WLAN
Bluetooth (WLAN-BT) combo module from MuRata which has a Marvell WLAN
(88W8686) + CSR Bluetooth chipset.

I can connect to an AP, but the performance is too low. Pinging my AP
I see a lot of 'Rx invalid crypt' and 'Invalid misc' packets.

I'm using the libertas driver from mainline kernel (2.6.35-rc3) with
SDIO interface and these errors are reported using the iwconfig
command.

I also tested with 2.6.34 and 2.6.33 with same result.

Any idea about what this means ? What could be wrong? Or how can I
investigate more ?

Thanks in advance,

Enric
