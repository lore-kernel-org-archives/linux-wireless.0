Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbXEZECE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 00:02:04 -0400
Subject: Please pull 'master' branch of libertas-for-linville
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sat, 26 May 2007 00:05:37 -0400
Message-Id: <1180152337.23264.5.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit b1f15a631ea3ab6c6dc2e2378b2cd43c1386a8f3

Found in the git repository at:

git://git.infradead.org/~dcbw/libertas-for-linville

This catches wireless-2.6 up to libertas-2.6 head.  We'll rebase
libertas-2.6 to wireless-2.6 when the changes get picked up, and then I
won't have to do hours of manual merges ever again :)

Thanks!
Dan


 b/drivers/net/wireless/Kconfig               |   18 
 b/drivers/net/wireless/libertas/11d.c        |  152 +-
 b/drivers/net/wireless/libertas/11d.h        |    6 
 b/drivers/net/wireless/libertas/Makefile     |    4 
 b/drivers/net/wireless/libertas/README       |   52 
 b/drivers/net/wireless/libertas/assoc.c      |  349 ++++--
 b/drivers/net/wireless/libertas/assoc.h      |    8 
 b/drivers/net/wireless/libertas/cmd.c        |  559 ++++------
 b/drivers/net/wireless/libertas/cmdresp.c    |  360 ++----
 b/drivers/net/wireless/libertas/debugfs.c    |  427 +++----
 b/drivers/net/wireless/libertas/decl.h       |   20 
 b/drivers/net/wireless/libertas/defs.h       |  101 +
 b/drivers/net/wireless/libertas/dev.h        |   87 -
 b/drivers/net/wireless/libertas/ethtool.c    |   55 
 b/drivers/net/wireless/libertas/fw.c         |  111 -
 b/drivers/net/wireless/libertas/host.h       |   13 
 b/drivers/net/wireless/libertas/hostcmd.h    |  381 +++---
 b/drivers/net/wireless/libertas/if_bootcmd.c |    6 
 b/drivers/net/wireless/libertas/if_usb.c     |  448 ++++----
 b/drivers/net/wireless/libertas/if_usb.h     |   32 
 b/drivers/net/wireless/libertas/ioctl.c      |  286 +++--
 b/drivers/net/wireless/libertas/join.c       |  450 +++-----
 b/drivers/net/wireless/libertas/join.h       |   10 
 b/drivers/net/wireless/libertas/main.c       |  673 +++++-------
 b/drivers/net/wireless/libertas/rx.c         |   63 -
 b/drivers/net/wireless/libertas/scan.c       | 1505 ++++++++++++---------------
 b/drivers/net/wireless/libertas/scan.h       |   67 -
 b/drivers/net/wireless/libertas/thread.h     |    8 
 b/drivers/net/wireless/libertas/tx.c         |   74 -
 b/drivers/net/wireless/libertas/types.h      |   63 -
 b/drivers/net/wireless/libertas/wext.c       |  738 ++++++-------
 b/drivers/net/wireless/libertas/wext.h       |   13 
 drivers/net/wireless/libertas/fw.h           |   13 
 drivers/net/wireless/libertas/sbi.h          |   40 
 34 files changed, 3623 insertions(+), 3569 deletions(-)


