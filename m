Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbXFYVZs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2007 17:25:48 -0400
Subject: Please pull libertas-2.6 'upstream-fixes' branch
From: Dan Williams <dcbw@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 25 Jun 2007 17:29:52 -0400
Message-Id: <1182806992.10966.4.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

The following changes since commit 188e1f81ba31af1b65a2f3611df4c670b092bbac:
  Linus Torvalds (1):
        Linux 2.6.22-rc5

are found in the git repository at:

  git://git.infradead.org/libertas-2.6/ upstream-fixes

Dan Williams (4):
      libertas: style fixes
      libertas: kill wlan_scan_process_results
      libertas: fix WPA associations by handling ENABLE_RSN correctly
      libertas: remove private ioctls

 drivers/net/wireless/libertas/Makefile  |    2 +-
 drivers/net/wireless/libertas/README    |  275 --------
 drivers/net/wireless/libertas/assoc.c   |   28 +-
 drivers/net/wireless/libertas/cmd.c     |   12 +-
 drivers/net/wireless/libertas/cmdresp.c |   21 +
 drivers/net/wireless/libertas/hostcmd.h |    2 +-
 drivers/net/wireless/libertas/ioctl.c   | 1081 -------------------------------
 drivers/net/wireless/libertas/main.c    |    8 +-
 drivers/net/wireless/libertas/scan.c    |   51 +--
 drivers/net/wireless/libertas/wext.c    |  152 -----
 drivers/net/wireless/libertas/wext.h    |   45 +--
 11 files changed, 79 insertions(+), 1598 deletions(-)
 delete mode 100644 drivers/net/wireless/libertas/ioctl.c


