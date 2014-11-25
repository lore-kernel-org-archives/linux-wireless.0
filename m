Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:8416 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaKYTz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 14:55:58 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 0/2] brcm80211: minor rework
Date: Tue, 25 Nov 2014 20:55:52 +0100
Message-ID: <1416945354-23346-1-git-send-email-arend@broadcom.com> (sfid-20141125_205611_127854_09D22B1B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing my mistake in utils.c these two patches will
extend the information in the hardware debugfs file.

It is intended for 3.19 and applies to the master
branch of the wireless-next repository, ie.:

  commit 18ca43823f3ce111c6efb8cc90d9f35246527727
  Author: Amitkumar Karwar <akarwar@marvell.com>
  Date:   Tue Nov 25 06:43:06 2014 -0800

      mwifiex: add Tx status support for ACTION frames

Arend van Spriel (2):
  brcmutil: add helper function to format board revision
  brcmsmac: extend hardware info shown in debugfs

 drivers/net/wireless/brcm80211/brcmsmac/debug.c    | 40 +++++++++++++++-------
 drivers/net/wireless/brcm80211/brcmutil/utils.c    | 16 +++++++++
 .../net/wireless/brcm80211/include/brcmu_utils.h   |  2 ++
 3 files changed, 45 insertions(+), 13 deletions(-)

-- 
1.9.1

