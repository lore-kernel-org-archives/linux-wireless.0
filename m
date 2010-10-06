Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43593 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab0JFFuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 01:50:04 -0400
Received: by eyb6 with SMTP id 6so2726728eyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 22:50:03 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 0/3] b43: channel switching little cleaning
Date: Wed,  6 Oct 2010 07:50:05 +0200
Message-Id: <1286344208-32479-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It defines B43_SHM_SH_CHAN_40MHZ and simplifies channel switching for N-PHY.

Rafał Miłecki (3):
  b43: N-PHY: simplify channel switching
  b43: define B43_SHM_SH_CHAN_40MHZ
  b43: N-PHY: don't duplicate setting channel in shared memory

 drivers/net/wireless/b43/b43.h        |    3 ++-
 drivers/net/wireless/b43/phy_common.c |    6 ++++--
 drivers/net/wireless/b43/phy_n.c      |   32 ++++++++++----------------------
 3 files changed, 16 insertions(+), 25 deletions(-)

