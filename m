Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr17.hinet.net ([168.95.4.117]:42616 "EHLO msr17.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab1GLPNH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 11:13:07 -0400
From: Ali Bahar <ali@internetdog.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Ali Bahar <ali@internetdog.org>
Subject: [PATCH 0/2] staging: r8712u: Set ESSID/AP now possible before interface is brought Up.
Date: Tue, 12 Jul 2011 23:10:54 +0800
Message-Id: <1310483456-10543-1-git-send-email-ali@internetDog.org> (sfid-20110712_171313_528428_5B4AC9A9)
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

