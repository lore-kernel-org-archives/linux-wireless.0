Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32690 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab2KTAnB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 19:43:01 -0500
Date: Tue, 20 Nov 2012 01:42:58 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.7] NFC fixes
Message-ID: <20121120004258.GB15237@sortiz-mobl> (sfid-20121120_014305_252186_0CDABA3D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the first pull request for 3.7 NFC fixes.

We mostly have pn533 fixes here, 2 memory leaks and an early unlocking fix.
Moreover, we also have an LLCP adapter linked list insertion fix.

Thanks in advance for pulling them in.

The following changes since commit 65210946f31007d12efcf66586fdcaf6ff3fa8f9:

  Merge branch 'for-john' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2012-11-19 14:38:12 -0500)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git tags/nfc-fixes-3.7-1

for you to fetch changes up to 5b412fd11c918171c98a253d8a3484afa9f69ca5:

  NFC: Fix pn533 target mode memory leak (2012-11-20 00:09:26 +0100)

----------------------------------------------------------------
Szymon Janc (2):
      NFC: pn533: Fix missing lock while operating on commands list
      NFC: pn533: Fix use after free

Thierry Escande (2):
      NFC: Fix nfc_llcp_local chained list insertion
      NFC: Fix pn533 target mode memory leak

Waldemar Rymarkiewicz (1):
      NFC: pn533: Fix mem leak in pn533_in_dep_link_up

 drivers/nfc/pn533.c |   25 ++++++++++++++-----------
 net/nfc/llcp/llcp.c |    2 +-
 2 files changed, 15 insertions(+), 12 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
