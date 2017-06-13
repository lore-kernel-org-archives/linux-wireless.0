Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33508 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbdFMHic (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 03:38:32 -0400
Received: by mail-io0-f170.google.com with SMTP id t87so48670509ioe.0
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 00:38:31 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?5a2Z5bu65biM?= <ycsunjane@gmail.com>
Date: Tue, 13 Jun 2017 15:38:30 +0800
Message-ID: <CABWe71weMrbEA=htjdRpUBofKo04jeQ9B56xvUzq2zF1YBmQFg@mail.gmail.com> (sfid-20170613_093839_615937_058F3771)
Subject: ath9k: wds mode can not recieve any packets.
To: linux-wireless@vger.kernel.org, nbd@openwrt.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ath9k in 4addr wds mode. After a while the station will break off.
Station connectivity remains. But `ifconfig` cannot see any recv
packet.

wlan0     Link encap:Ethernet  HWaddr C8:EE:A6:2E:60:D8
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:17402577 errors:0 dropped:0 overruns:0 frame:0
          TX packets:33065526 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1165838023 (1.0 GiB)  TX bytes:51166664044 (47.6 GiB)

RX packets count stop increase.


/sys/kernel/debug/ieee80211/phy0/ath9k/recv
         PKTS-ALL :   21445223
         BYTES-ALL : 2458906640


  PKTS-ALL still increase.
