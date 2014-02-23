Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5654 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbaBWWvD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 17:51:03 -0500
Date: Sun, 23 Feb 2014 23:50:54 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@lists.01.org>
Subject: [GIT] [3.14] NFC fix
Message-ID: <20140223225054.GN18868@zurbaran> (sfid-20140223_235132_953741_932F49B3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

We only have one candidate for 3.14 fixes, and this is a NCI NULL
pointer dereference introduced during the 3.14 merge window.

The following changes since commit b3050248c167871ca52cfdb2ce78aa2460249346:

  ath9k: Fix ETSI compliance for AR9462 2.0 (2014-02-20 15:53:20 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.14-1

for you to fetch changes up to 44a589ca2de4d7980f8b335481a09bf818065dbe:

  NFC: NCI: Fix NULL pointer dereference (2014-02-23 23:14:45 +0100)

Amitkumar Karwar (1):
      NFC: NCI: Fix NULL pointer dereference

 net/nfc/nci/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
