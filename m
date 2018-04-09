Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:59690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752414AbeDIOKe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 10:10:34 -0400
Date: Mon, 9 Apr 2018 16:10:32 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
        Jakub =?utf-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: [ANN] mt76x0 usb driver
Message-ID: <20180409141032.GA9247@redhat.com> (sfid-20180409_161040_019781_C1B42688)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I would like to announce mt76x0 driver for MT7610U USB dongles:

https://github.com/sgruszka/mt76x0

mt76x0 is based on Jakub's mt7601u mac80211 driver and is intended to be
integrated in the linux kernel.

Currently only Linksys AE6000 (ID 13b1:003e) in on USB id's list
and 5GHz does not work.

I would like to integrate the driver to kernel via mt76 driver, i.e.
add USB hooks and mt76x0 mac/phy code to mt76. This will open
possibility to develop support for mt76x2 USB devices as well as mt76x0
PCIe devices in mt76.

I would also like to establish some better collaboration with Mediatek
in order to having their present and future wireless hardware be
supported in the mainline kernel.

Thanks
Stanislaw
