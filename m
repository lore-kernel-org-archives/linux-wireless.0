Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4513 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760702Ab2EJRgX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 13:36:23 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 1/2] NFC: Export nfc.h to userland
Date: Thu, 10 May 2012 19:45:51 +0200
Message-Id: <1336671952-22678-2-git-send-email-sameo@linux.intel.com> (sfid-20120510_194241_105689_8422590E)
In-Reply-To: <1336671952-22678-1-git-send-email-sameo@linux.intel.com>
References: <1336671952-22678-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The netlink commands and attributes, along with the socket structure
definitions need to be exported.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 3c9b616..f08e3ae 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -271,6 +271,7 @@ header-y += netfilter_ipv4.h
 header-y += netfilter_ipv6.h
 header-y += netlink.h
 header-y += netrom.h
+header-y += nfc.h
 header-y += nfs.h
 header-y += nfs2.h
 header-y += nfs3.h
-- 
1.7.9.1

