Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbXEKDIz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 23:08:55 -0400
Subject: [PATCH 06/19] libertas: remove incorrect vi modelines
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178852086.8607.23.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
	 <1178852086.8607.23.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 23:12:27 -0400
Message-Id: <1178853147.8607.58.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I screwed up formatting, please use this one.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/join.h |    3 ---
 drivers/net/wireless/libertas/scan.c |    3 ---
 drivers/net/wireless/libertas/scan.h |    3 ---
 3 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/libertas/join.h b/drivers/net/wireless/libertas/join.h
index 8efa245..0e6d928 100644
--- a/drivers/net/wireless/libertas/join.h
+++ b/drivers/net/wireless/libertas/join.h
@@ -1,6 +1,3 @@
-/* -*- mode: C; tab-width: 4; indent-tabs-mode: nil -*- */
-/* vi: set expandtab shiftwidth=4 tabstop=4 textwidth=78: */
-
 /**
   * Interface for the wlan infrastructure and adhoc join routines
   *
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 400558a..29b1192 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -1,6 +1,3 @@
-/* -*- mode: C; tab-width: 4; indent-tabs-mode: nil -*- */
-/* vi: set expandtab shiftwidth=4 tabstop=4 textwidth=78: */
-
 /**
   * Functions implementing wlan scan IOCTL and firmware command APIs
   *
diff --git a/drivers/net/wireless/libertas/scan.h b/drivers/net/wireless/libertas/scan.h
index 1a8756e..486bdc4 100644
--- a/drivers/net/wireless/libertas/scan.h
+++ b/drivers/net/wireless/libertas/scan.h
@@ -1,6 +1,3 @@
-/* -*- mode: C; tab-width: 4; indent-tabs-mode: nil -*- */
-/* vi: set expandtab shiftwidth=4 tabstop=4 textwidth=78: */
-
 /**
   * Interface for the wlan network scan routines
   *
-- 
1.5.0.6



