Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:36512 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab1ARJaO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 04:30:14 -0500
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p0I9UD0O020832
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 03:30:13 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: PATCH v2  0/2] wl12xx: BA Initiator & receiver support
Date: Tue, 18 Jan 2011 11:32:17 +0200
Message-Id: <1295343139-25375-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That series gather two patches:
[PATCH v6] wl12xx: BA initiator support
[PATCH v4] wl12xx: BA receiver support

Add 80211n BA initiator & receiver session support wl1271 driver.
BA initiator session management included in FW independently.
Include supported FW version auto detection mechanism.

Limitation:
- For now only one BA per direction is supported

Shahar Levi (2):
  wl12xx: BA initiator support
  wl12xx: BA receiver support

 drivers/net/wireless/wl12xx/acx.c    |   85 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h    |   62 ++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/boot.c   |   24 ++++++++-
 drivers/net/wireless/wl12xx/conf.h   |    6 ++
 drivers/net/wireless/wl12xx/init.c   |   41 ++++++++++++++++
 drivers/net/wireless/wl12xx/main.c   |   71 ++++++++++++++++++++++++++--
 drivers/net/wireless/wl12xx/wl12xx.h |   16 ++++++-
 7 files changed, 295 insertions(+), 10 deletions(-)

