Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:43916 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab0G0Wx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 18:53:26 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Pull request: bluetooth-next-2.6 2010-07-27
Date: Tue, 27 Jul 2010 15:53:11 -0700
Message-Id: <cover.1280270806.git.marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I have a few more patches for the 2.6.36 merge window. Besides the SCO
setup fix they are just cleanups anyway.

Regards

Marcel


Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-next-2.6.git master

This will update the following files:

 drivers/bluetooth/hci_ath.c      |    6 +-
 drivers/bluetooth/hci_bcsp.c     |    4 +-
 drivers/bluetooth/hci_h4.c       |  107 ++------------------------------------
 drivers/bluetooth/hci_ll.c       |    4 +-
 include/net/bluetooth/hci_core.h |    2 +
 net/bluetooth/hci_conn.c         |   32 ++++++++++--
 net/bluetooth/hci_core.c         |    8 ++--
 net/bluetooth/hci_event.c        |   31 +++++------
 net/bluetooth/rfcomm/sock.c      |    2 +-
 net/bluetooth/rfcomm/tty.c       |    4 +-
 10 files changed, 63 insertions(+), 137 deletions(-)
 mode change 100755 => 100644 drivers/bluetooth/hci_ath.c

through these ChangeSets:

Dan Carpenter (1):
    Bluetooth: Fix kfree() => kfree_skb() in hci_ath.c

Gustavo F. Padovan (5):
    Bluetooth: Fix permission of hci_ath.c
    Bluetooth: Test 'count' value before enter the loop
    Bluetooth: Use hci_recv_stream_fragment() in UART driver
    Bluetooth: Add __init and __exit marks to UART drivers
    Bluetooth: Add __init and __exit marks to RFCOMM

Marcel Holtmann (1):
    Bluetooth: Defer SCO setup if mode change is pending

