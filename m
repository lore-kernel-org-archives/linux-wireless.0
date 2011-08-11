Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52904 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1HKUPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 16:15:31 -0400
Received: by qwk3 with SMTP id 3so1247598qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 13:15:30 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Aug 2011 22:15:30 +0200
Message-ID: <CAPH1DO2bWghrK5zPquB52bLbLLSDQZ44kuaFjubbVFWEjNteNg@mail.gmail.com> (sfid-20110811_221535_059617_A043C0E5)
Subject: ipw2200
From: Bo Nilsson <mr.bonilsson@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is linux braking down? I never had a problem like this before. I will
have to go back to debian 5 and see if that is stable still.

root@debian:/home/bo# dmesg | grep ipw2200
[    3.664058] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network
Driver, 1.2.2kmprq
[    3.664062] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[    3.954370] ipw2200 0000:02:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.956831] ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
[    3.956881] ipw2200 0000:02:06.0: firmware: requesting ipw2200-bss.fw
[    4.590967] ipw2200: Detected geography ZZR (14 802.11bg channels,
0 802.11a channels)
[  251.494725] ipw2200: Firmware error detected.  Restarting.
