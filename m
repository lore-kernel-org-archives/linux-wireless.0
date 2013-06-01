Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f49.google.com ([209.85.128.49]:45437 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3FAR5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 13:57:37 -0400
Received: by mail-qe0-f49.google.com with SMTP id a11so1568256qen.36
        for <linux-wireless@vger.kernel.org>; Sat, 01 Jun 2013 10:57:37 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Marc_Mar=ED?= <5.markmb.5@gmail.com>
Date: Sat, 1 Jun 2013 17:57:17 +0000
Message-ID: <CA+nFU8T5Ja9jg_E7=Y4TbsT+OxJfNy=x18CMm3VUA9BcKb1+WA@mail.gmail.com> (sfid-20130601_195741_034710_3F4905E2)
Subject: Intel Centrino Advanced N 6200 and Debian 7
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone

I recently changed my wireless card from a Broadcom (very bad
supported) to a Intel Centrino Advanced N 6200. In Fedora, it works
well, but I prefer Debian, and I'll change again, but in a Debian 7
live CD (I need my laptop, so I can't stay several days with a half
installation) the wifi doesn't work (kernel 3.2.0-4). This is the
error

Jun  1 17:36:54 localhost kernel: [ 1355.470587] cfg80211: Calling
CRDA to update world regulatory domain
Jun  1 17:36:54 localhost kernel: [ 1355.477124] Intel(R) Wireless
WiFi Link AGN driver for Linux, in-tree:
Jun  1 17:36:54 localhost kernel: [ 1355.477127] Copyright(c)
2003-2011 Intel Corporation
Jun  1 17:36:54 localhost kernel: [ 1355.477262] iwlwifi 0000:03:00.0:
setting latency timer to 64
Jun  1 17:36:54 localhost kernel: [ 1355.477308] iwlwifi 0000:03:00.0:
pci_resource_len = 0x00002000
Jun  1 17:36:54 localhost kernel: [ 1355.477310] iwlwifi 0000:03:00.0:
pci_resource_base = ffffc900111a8000
Jun  1 17:36:54 localhost kernel: [ 1355.477313] iwlwifi 0000:03:00.0:
HW Revision ID = 0x0
Jun  1 17:36:54 localhost kernel: [ 1355.477726] iwlwifi 0000:03:00.0:
irq 48 for MSI/MSI-X
Jun  1 17:36:54 localhost kernel: [ 1355.477842] iwlwifi 0000:03:00.0:
Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
Jun  1 17:36:54 localhost kernel: [ 1355.478018] iwlwifi 0000:03:00.0:
L1 Enabled; Disabling L0S
Jun  1 17:36:54 localhost kernel: [ 1355.480134] cfg80211: World
regulatory domain updated:
Jun  1 17:36:54 localhost kernel: [ 1355.480136] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jun  1 17:36:54 localhost kernel: [ 1355.480139] cfg80211:
(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jun  1 17:36:54 localhost kernel: [ 1355.480141] cfg80211:
(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jun  1 17:36:54 localhost kernel: [ 1355.480143] cfg80211:
(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jun  1 17:36:54 localhost kernel: [ 1355.480145] cfg80211:
(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jun  1 17:36:54 localhost kernel: [ 1355.480147] cfg80211:
(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jun  1 17:36:54 localhost kernel: [ 1355.505261] iwlwifi 0000:03:00.0:
Unsupported (too old) EEPROM VER=0x416 < 0x423 CALIB=0x5 < 0x4
Jun  1 17:36:54 localhost kernel: [ 1355.505393] iwlwifi: probe of
0000:03:00.0 failed with error -22

Searching the web, it seems that the error is not very common, but is
a weird thing, so I am asking for any support in this.

Thank you in advance
Marc
