Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43877 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab0AAQVw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2010 11:21:52 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/5] compat-wireless: Activate ssb and libertas, refresh script
Date: Fri,  1 Jan 2010 17:21:07 +0100
Message-Id: <1262362872-10251-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first two patches were already send some time ago, but not applied, 
the second patch was applied partly. Patch 3 adds an refresh option to 
admin-update.sh and it was used in patch 4. The last patch fixes some 
small problems in admin-update.sh

Hauke Mehrtens (5):
  [RESEND] compat-wireless: Activate ssb and libertas
  compat-wireless: Add missing file
  This adds a refresh option to admin-update.sh using quilt.
  compat-wireless: Refresh patches
  compat-wireless: small fixes to admin-update.sh

 Makefile                                     |    5 +-
 config.mk                                    |    2 +-
 patches/01-netdev.patch                      |  165 +++++-----
 patches/02-ksize.patch                       |    6 +-
 patches/03-rfkill.patch                      |   44 ++--
 patches/04-netns.patch                       |    6 +-
 patches/05-usb.patch                         |    6 +-
 patches/06-header-changes.patch              |   12 +-
 patches/07-change-default-rate-alg.patch     |    4 +-
 patches/08-rename-iwl4965-config.patch       |   10 +-
 patches/09-threaded-irq.patch                |   16 +-
 patches/10-add-wext-handlers-to-netdev.patch |    6 +-
 patches/11-dev-pm-ops.patch                  |    8 +-
 patches/12-iw_handler-changes.patch          |    6 +-
 patches/13-trace.patch                       |   10 +-
 patches/14-device-type.patch                 |   10 +-
 patches/15-symbol-export-conflicts.patch     |    6 +-
 patches/16-bluetooth.patch                   |  481 ++++++++++++--------------
 patches/17-netdev-queue.patch                |    8 +-
 patches/18-rename-usb-net-symbols.patch      |   52 +++
 patches/19-kfifo.patch                       |    4 +-
 patches/99-change-makefiles.patch            |   27 +-
 scripts/admin-refresh.sh                     |    4 +-
 scripts/admin-update.sh                      |   53 +++-
 24 files changed, 506 insertions(+), 445 deletions(-)
 create mode 100644 patches/18-rename-usb-net-symbols.patch

