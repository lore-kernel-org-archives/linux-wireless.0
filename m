Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:34085 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbeFVIhh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jun 2018 04:37:37 -0400
Received: by mail-qt0-f178.google.com with SMTP id d3-v6so5314074qto.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2018 01:37:37 -0700 (PDT)
MIME-Version: 1.0
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Date: Fri, 22 Jun 2018 10:37:35 +0200
Message-ID: <CAFED-jkby2sk9OQnuH5PD8isr0n_CM6Eufs7Ds5fhavYfYdLBw@mail.gmail.com> (sfid-20180622_103743_270083_4EF3A910)
Subject: mt76x2e MCU message 31 timed out
To: linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Have this card in my laptop:
02:00.0 Network controller: MEDIATEK Corp. Device 7612

[    8.478104] mt76x2e 0000:02:00.0: ASIC revision: 76120044
[    8.489582] mt76x2e 0000:02:00.0: ROM patch already applied
[    8.833476] mt76x2e 0000:02:00.0: Firmware Version: 0.0.00
[    8.833477] mt76x2e 0000:02:00.0: Build: 1
[    8.833479] mt76x2e 0000:02:00.0: Build Time: 201507311614____
[    8.856115] mt76x2e 0000:02:00.0: Firmware running!
[    9.558075] mt76x2e 0000:02:00.0 wlp2s0: renamed from wlan1

Linux test4 4.17.0-rc7+ #5 SMP Mon May 28 12:35:22 CEST 2018 x86_64 GNU/Linux

Seems iw scan works correctly and first assoc. After will run some
traffic (iperf in such case) get:

[  432.372081] wlp2s0: associate with 52:b4:f7:f0:16:c2 (try 2/3)
[  432.375255] wlp2s0: RX AssocResp from 52:b4:f7:f0:16:c2
(capab=0x511 status=0 aid=2)
[  432.375336] wlp2s0: associated
[  432.451097] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
[  522.562157] mt76x2e 0000:02:00.0: MCU message 31 (seq 13) timed out
[  524.610281] mt76x2e 0000:02:00.0: MCU message 31 (seq 14) timed out
[  526.658384] mt76x2e 0000:02:00.0: MCU message 31 (seq 15) timed out
[  528.258455] mt76x2e 0000:02:00.0: MCU message 30 (seq 1) timed out
[  529.282499] mt76x2e 0000:02:00.0: MCU message 30 (seq 2) timed out
[  530.402544] mt76x2e 0000:02:00.0: MCU message 30 (seq 3) timed out
[  531.426587] mt76x2e 0000:02:00.0: MCU message 30 (seq 4) timed out
[  531.427444] wlp2s0: authenticate with 52:b4:f7:f0:14:ac
[  532.450624] mt76x2e 0000:02:00.0: MCU message 30 (seq 5) timed out
[  533.474666] mt76x2e 0000:02:00.0: MCU message 30 (seq 6) timed out
[  534.498709] mt76x2e 0000:02:00.0: MCU message 30 (seq 7) timed out
[  535.522736] mt76x2e 0000:02:00.0: MCU message 30 (seq 8) timed out
[  535.522807] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 1/3)
[  535.726740] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 2/3)
[  535.930742] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 3/3)
[  536.134747] wlp2s0: authentication with 52:b4:f7:f0:14:ac timed out

Any hints?

BR
Janusz
