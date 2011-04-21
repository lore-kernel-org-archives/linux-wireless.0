Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:43106 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab1DUUao (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 16:30:44 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 13:30:18 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>, <kvalo@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 0/5] ath6kl: AR6003 v2.1.1 support
Date: Thu, 21 Apr 2011 13:30:35 -0700
Message-ID: <1303417840-19605-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg,

here's a respin of Naveen's patches cleaned up and sanitized, and
also fixed to apply on top of your staging-next branch as of today.
Will be sending the respective firmware files to David later once
I get them from our team. You will see whitespace noise on the patches
but these complaints are for places where the code is already idented
in a non-standard way. More cleanup will be underway later.

Naveen Singh (5):
  ath6kl: add support for AR6003 v2.1.1
  ath6kl: Extend WMI API used by AR6003 v2.1.1
  ath6kl: add the device ID on the data command packet
  ath6kl: fix scan operation while disconnect
  ath6kl: fix operations for power management

 drivers/staging/ath6kl/include/common/targaddrs.h  |  226 +++++++++++++++++---
 drivers/staging/ath6kl/include/common/wmi.h        |  118 +++++++++--
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |  133 +++++++++---
 drivers/staging/ath6kl/os/linux/cfg80211.c         |    8 +-
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |   57 +++++-
 drivers/staging/ath6kl/wmi/wmi.c                   |   23 +--
 6 files changed, 453 insertions(+), 112 deletions(-)

-- 
1.7.4.15.g7811d

