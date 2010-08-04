Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:49206 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934827Ab0HDUiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 16:38:20 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Pull request: bluetooth-next-2.6 2010-08-04
Date: Wed,  4 Aug 2010 13:38:14 -0700
Message-Id: <cover.1280932089.git.marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I have four more bug fixes for the 2.6.36 merge window. All of them
are pretty straight forward.

They are still based on your wireless-next-2.6 tree. I hope that is
no problem for you. I can rebase them quickly if needed.

Regards

Marcel


Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-next-2.6.git master

This will update the following files:

 include/net/bluetooth/hci_core.h |    2 +-
 net/bluetooth/hci_core.c         |    2 +-
 net/bluetooth/hci_sock.c         |    8 +++-----
 net/bluetooth/hci_sysfs.c        |    3 +--
 net/bluetooth/l2cap.c            |   24 +++++++++++++++++++++---
 net/bluetooth/rfcomm/tty.c       |    2 +-
 6 files changed, 28 insertions(+), 13 deletions(-)

through these ChangeSets:

David Miller (1):
    Bluetooth: Use list_head for HCI blacklist head

Gustavo F. Padovan (2):
    Bluetooth: Remove __exit from rfcomm_cleanup_ttys()
    Bluetooth: Don't send RFC for Basic Mode if only it is supported

Ville Tervo (1):
    Bluetooth: Check result code of L2CAP information response

