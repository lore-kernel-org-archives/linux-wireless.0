Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:45496 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbeAYLON (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 06:14:13 -0500
From: Tobias Schramm <tobleminer@gmail.com>
To: kvalo@qca.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org
Cc: Tobias Schramm <tobleminer@gmail.com>
Subject: [PATCH v3 0/2] ath10k: Add support for Ubiquiti-branded QCA988X
Date: Thu, 25 Jan 2018 12:13:38 +0100
Message-Id: <20180125111340.17553-1-tobleminer@gmail.com> (sfid-20180125_121417_505919_77D3DA30)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A lot of more modern Ubiquiti AirMAX wireless devices contain a rebranded
QCA988X with changed PCI vendor and device id.
This patch adds support for those chips by treating them as QCA988X rev2
radios.

Changes since v1:
 * Send patch to more people and lists

Changes since v2:
 * Rename PCI_VENDOR_ID_UBNT to PCI_VENDOR_ID_UBIQUITI

Tobias Schramm (2):
  pci: Add vendor id of Ubiquiti Networks
  ath10k: Add support for Ubiquiti rebranded QCA988X v2

 drivers/net/wireless/ath/ath10k/core.c | 24 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  1 +
 drivers/net/wireless/ath/ath10k/pci.c  |  4 ++++
 include/linux/pci_ids.h                |  2 ++
 4 files changed, 31 insertions(+)

-- 
2.16.0
