Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from libra.uberspace.de ([95.143.172.171]:50238 "EHLO
        libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbcIDT1P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Sep 2016 15:27:15 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: Matthias Beyer <mail@beyermatthias.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Manuel Messner <manuel.johannes.messner@hs-furtwangen.de>,
        Geliang Tang <geliangtang@163.com>,
        Cihangir Akturk <cakturk@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Some cleanup patches for drivers/staging/rtl8723au/core/rtw_mlme.c
Date: Sun,  4 Sep 2016 21:26:21 +0200
Message-Id: <20160904192626.17197-1-mail@beyermatthias.de> (sfid-20160904_212719_743641_008386DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset fixes some errors and warnings reported by checkpatch.pl.

Matthias Beyer (5):
  drivers: staging: rtl8723au: core: Fix checkpatch.pl errors
  drivers: staging: rtl8723au: core: simplify if-break-else
  drivers: staging: rtl8723au: core: Refactor pointless branching
  drivers: staging: rtl8723au: core: Fix "space prohibited" warning
  drivers: staging: rtl8723au: core: Fix indentation

 drivers/staging/rtl8723au/core/rtw_mlme.c | 72 ++++++++++++++-----------------
 1 file changed, 33 insertions(+), 39 deletions(-)

-- 
2.9.3
