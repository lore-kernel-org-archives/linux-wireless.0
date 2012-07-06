Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56717 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab2GFWl6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 18:41:58 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 0/2] NFC fixes for 3.5
Date: Sat,  7 Jul 2012 00:53:17 +0200
Message-Id: <1341615199-11246-1-git-send-email-sameo@linux.intel.com> (sfid-20120707_004202_705123_E94FBF1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I have a couple of HCI fixes from Mathias, for 3.5. Thanks in advance for
pulling them in.

You can pull them from:

git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git tags/nfc-fixes-3.5-2


Mathias Jeppsson (2):
  NFC: Fix empty HCI message list check
  NFC: Fix order of arguments to list_add_tail() when queueing HCP
    frames

 net/nfc/hci/core.c |    5 ++---
 net/nfc/hci/hcp.c  |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

-- 
1.7.10

