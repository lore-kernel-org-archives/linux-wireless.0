Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40026 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752083AbdATNjl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 08:39:41 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Gabor Juhos <juhosg@openwrt.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Mathias Kresin <dev@kresin.me>,
        Michel Stempin <michel.stempin@wanadoo.fr>,
        John Crispin <blogic@openwrt.org>
Subject: [PATCH v4 0/3] rt2x00: RT5350 support
Date: Fri, 20 Jan 2017 14:28:23 +0100
Message-Id: <1484918906-21856-1-git-send-email-sgruszka@redhat.com> (sfid-20170120_143944_527907_014F83B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Repost patches from Daniel with updated clock handling and
correct author of RT5350 patch.

Note I did not test patches on SOC devices, but getting
clock frequency is simple and should be trouble-free.

Daniel Golle (1):
  rt2x00: rt2800lib: add support for RT3352 with 20MHz crystal

Serge Vasilugin (1):
  rt2x00: add support for RT5350 WiSoC

Stanislaw Gruszka (1):
  rt2x00: add copy of clk for soc devices

 drivers/net/wireless/ralink/rt2x00/rt2800.h    |   1 +
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 156 +++++++++++++++++++++++--
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    |   5 +
 drivers/net/wireless/ralink/rt2x00/rt2x00soc.c |   1 +
 4 files changed, 155 insertions(+), 8 deletions(-)

-- 
1.8.3.1
