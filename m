Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943Ab2BCQcW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 11:32:22 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 00/25] iwlegacy update 2012-02-03
Date: Fri,  3 Feb 2012 17:31:36 +0100
Message-Id: <1328286721-11309-1-git-send-email-sgruszka@redhat.com> (sfid-20120203_173225_481302_2F7B2016)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set include various cleanups, mostly patches intended
to remove unused "ctx" structure.

v2 compile with CONFIG_IWLEGACY_DEBUGFS and does not change
rt2x00 driver.

 3945-mac.c   |  186 ++++++----------
 3945-rs.c    |    7 
 3945.c       |  111 ++++-----
 3945.h       |    6 
 4965-calib.c |   24 --
 4965-mac.c   |  512 ++++++++++++++++++++++++----------------------
 4965-rs.c    |   48 +---
 4965.c       |  328 +++++++++--------------------
 4965.h       |   22 -
 common.c     |  656 +++++++++++++++++++++++------------------------------------
 common.h     |  234 +++++++--------------
 debug.c      |   43 +--
 12 files changed, 909 insertions(+), 1268 deletions(-)

