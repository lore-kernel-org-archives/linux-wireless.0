Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57300 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161288Ab2GLRRp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 13:17:45 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 0/2] NFC fixes for 3.5
Date: Thu, 12 Jul 2012 19:17:32 +0200
Message-Id: <1342113454-23110-1-git-send-email-sameo@linux.intel.com> (sfid-20120712_191749_627915_87AF5B1F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

The 3rd and hopefully last pull request for NFC fixes.
You can pull them from:

git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git tags/nfc-fixes-3.5-3

Dave Jones (1):
  NFC: NCI module license 'unspecified' taints kernel

Eric Lapuyade (1):
  NFC: Set target nfcid1 for all HCI reader A targets

 net/nfc/hci/core.c |   15 +++++++++++++++
 net/nfc/nci/core.c |    3 +++
 2 files changed, 18 insertions(+)

-- 
1.7.10

