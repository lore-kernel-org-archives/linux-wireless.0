Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63292 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1BHEHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 23:07:01 -0500
Date: Tue, 8 Feb 2011 02:07:30 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-2.6 2011-02-08
Message-ID: <20110208040730.GA2069@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Two fixes for 2.6.38. Support for firmware download for the Atheros AR9285
device and a fix two prevent multiple connection responses to one connection
request.

Please pull, or tell me any problem. Thanks.

The following changes since commit fc7c976dc7a565213393ce700d4a6105f037bf20:

  mac80211: fix the skb cloned check in the tx path (2011-02-07 16:02:14 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master

Bao Liang (1):
      Bluetooth: Set conn state to BT_DISCONN to avoid multiple responses

Cho, Yu-Chen (1):
      Bluetooth: add Atheros BT AR9285 fw supported

 drivers/bluetooth/ath3k.c |    2 ++
 drivers/bluetooth/btusb.c |    3 +++
 net/bluetooth/l2cap.c     |    1 +
 3 files changed, 6 insertions(+), 0 deletions(-)

-- 
Gustavo F. Padovan
http://profusion.mobi
