Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:49384 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab0HJMFr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 08:05:47 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Pull request: bluetooth-2.6 2010-08-10
Date: Tue, 10 Aug 2010 08:05:38 -0400
Message-Id: <cover.1281441611.git.marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

these patches are for 2.6.36 merge window. They are fixing the regressions
with L2CAP ERTM support that haven been found recently.

Regards

Marcel


Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git master

This will update the following files:

 include/net/bluetooth/l2cap.h |    4 ++--
 net/bluetooth/l2cap.c         |   11 +++++------
 2 files changed, 7 insertions(+), 8 deletions(-)

through these ChangeSets:

Mat Martineau (4):
    Bluetooth: Fix endianness issue with L2CAP MPS configuration
    Bluetooth: Change default L2CAP ERTM retransmit timeout
    Bluetooth: Fix incorrect setting of remote_tx_win for L2CAP ERTM
    Bluetooth: Use 3-DH5 payload size for default ERTM max PDU size

