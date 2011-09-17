Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33322 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab1IQU0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 16:26:05 -0400
Date: Sat, 17 Sep 2011 17:26:34 -0300
From: Gustavo Padovan <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2011-09-17
Message-ID: <20110917202634.GA3819@joana> (sfid-20110917_222640_781705_F74F5697)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is probably my unique pull request for 3.1, it fixes an regression with
the HCI_INQUIRY flag, it was not getting cleaned after scan. Fix by Oliver
Neukum. Also support for two new apple devices and a simple fix the to
btwilink driver.

Please pull, or let me know any problem. Thanks.

	Gustavo

The following changes since commit 2249b011432ca3dcce112f0f71e0f531b4bb9347:

  iwlagn: workaround bug crashing some APs (2011-09-16 15:32:12 -0400)

are available in the git repository at:
  git://github.com/padovan/bluetooth-next.git for-3.1

Chen Ganir (1):
      Bluetooth: Fixed BT ST Channel reg order

Jurgen Kramer (1):
      Bluetooth: add support for 2011 mac mini

Oliver Neukum (1):
      Bluetooth: Fix timeout on scanning for the second time

Pieter-Augustijn Van Malleghem (1):
      Bluetooth: Add MacBookAir4,1 support

 drivers/bluetooth/btusb.c    |    6 ++++++
 drivers/bluetooth/btwilink.c |   16 ++++++++--------
 net/bluetooth/hci_event.c    |   17 ++++++++---------
 3 files changed, 22 insertions(+), 17 deletions(-)
