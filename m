Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vervifontaine.sonycom.com ([80.88.33.193]:58791 "EHLO
	pophost.sonytel.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752741Ab0A1MXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 07:23:38 -0500
From: Hamish Guthrie <hamish.guthrie@sonycom.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, geoffrey.levand@am.sony.com,
	cbe-oss-dev@ozlabs.org, Hamish Guthrie <hamish.guthrie@sonycom.com>
Subject: [PATCH 0/2] Remove legacy wpa support and fix directed ssid scan
Date: Thu, 28 Jan 2010 12:54:08 +0100
Message-Id: <1264679650-14201-1-git-send-email-hamish.guthrie@sonycom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes deprecated legacy wpa_supplicant support and fixes directed
ssid scans.


  ps3_gelic_wireless: Remove PS3 gelic legacy wpa support
  ps3_gelic_wireless: fix directed ssid scan

 arch/powerpc/configs/ppc64_defconfig |    1 -
 arch/powerpc/configs/ps3_defconfig   |    1 -
 drivers/net/Kconfig                  |   14 ---
 drivers/net/ps3_gelic_wireless.c     |  152 ++--------------------------------
 4 files changed, 9 insertions(+), 159 deletions(-)

