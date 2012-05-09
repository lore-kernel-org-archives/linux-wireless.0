Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31487 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab2EIMw3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 08:52:29 -0400
Date: Wed, 9 May 2012 15:02:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: [PATCH 3.4] NFC: Export nfc.h to userland
Message-ID: <20120509130208.GA1794@sortiz-mobl> (sfid-20120509_145233_316654_8425DC2E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
