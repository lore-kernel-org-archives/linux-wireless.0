Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-132.163.com ([123.125.50.132]:40505 "EHLO m50-132.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423084AbcBQNtu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 08:49:50 -0500
From: Geliang Tang <geliangtang@163.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Julian Calaby <julian.calaby@gmail.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] staging: rtl8723au: use list_for_each_entry*() and cleaning
Date: Wed, 17 Feb 2016 21:48:22 +0800
Message-Id: <cover.1455715186.git.geliangtang@163.com> (sfid-20160217_145046_938547_A977C0AD)
In-Reply-To: <wrfj4mdaxa40.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set uses list_for_each_entry*() instead of
list_for_each*(), removes useless codes, and cleans
whitespaces and blank lines.

Changes in v4:
 - revise the patchs as Jes suggested.
Changes in v3:
 - split it into three patches.
Changes in v2:
 - drop the coding style fixing in v1.

Geliang Tang (3):
  staging: rtl8723au: use list_for_each_entry*()
  staging: rtl8723au: core: rtw_recv: remove useless codes
  staging: rtl8723au: whitespace and blank line cleaning

 drivers/staging/rtl8723au/core/rtw_ap.c           | 92 ++++++-----------------
 drivers/staging/rtl8723au/core/rtw_mlme.c         | 38 +++-------
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c     | 13 ++--
 drivers/staging/rtl8723au/core/rtw_recv.c         | 42 ++++-------
 drivers/staging/rtl8723au/core/rtw_sta_mgt.c      | 36 +++------
 drivers/staging/rtl8723au/core/rtw_xmit.c         | 90 ++++++++--------------
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 22 ++----
 drivers/staging/rtl8723au/os_dep/usb_ops_linux.c  |  9 +--
 8 files changed, 106 insertions(+), 236 deletions(-)

-- 
2.5.0


