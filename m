Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr4.hinet.net ([168.95.4.104]:33967 "EHLO msr4.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab1GKMP3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 08:15:29 -0400
From: Ali Bahar <ali@internetdog.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, WLAN FAE <wlanfae@realtek.com>,
	Ali Bahar <ali@internetdog.org>
Subject: [PATCH 0/2] staging: r8712u: Set ESSID/AP now possible before interface is brought Up.
Date: Mon, 11 Jul 2011 18:07:54 +0800
Message-Id: <1310378876-1311-1-git-send-email-ali@internetDog.org> (sfid-20110711_141535_308424_E719B621)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are updates to how the 'bup' flag is handled. The first allows Sets
before the interface is brought Up, and the second is housekeeping of the
flag's value when the interface is taken Down.

Ali Bahar (2):
  staging: r8712u: Sets to SSID, and to AP MAC#, can now be done    
    when the interface is Down.
  staging: r8712u: Interface-state not fully tracked.

 drivers/staging/rtl8712/drv_types.h           |    5 +++++
 drivers/staging/rtl8712/os_intfs.c            |   14 ++++++++++++++
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |   25 +++++++++++++++++++++----
 3 files changed, 40 insertions(+), 4 deletions(-)

-- 
1.7.6

