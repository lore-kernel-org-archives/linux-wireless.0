Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:45100 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbeAYHmF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 02:42:05 -0500
From: Tobias Schramm <tobleminer@gmail.com>
To: kvalo@qca.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org
Cc: Tobias Schramm <tobleminer@gmail.com>
Subject: [PATCH v2 0/2] ath10k: Add support for Ubiquiti-branded QCA988X
Date: Thu, 25 Jan 2018 08:41:29 +0100
Message-Id: <20180125074131.30622-1-tobleminer@gmail.com> (sfid-20180125_084212_501488_01F26FB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A lot of more modern Ubiquiti AirMAX wireless devices contain a rebranded
QCA988X with changed PCI vendor and device id.
This patch adds support for those chips by treating them as QCA988X rev2
radios.

Changes since v1:
 * Send patch to more people and lists


Tobias Schramm (2):
  pci: Add vendor id of Ubiquiti Networks
  ath10k: Add support for Uiquiti rebranded QCA988X v2

 drivers/net/wireless/ath/ath10k/core.c | 24 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  1 +
 drivers/net/wireless/ath/ath10k/pci.c  |  4 ++++
 include/linux/pci_ids.h                |  2 ++
 4 files changed, 31 insertions(+)

-- 
2.16.0
