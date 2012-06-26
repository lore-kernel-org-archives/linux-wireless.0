Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12328 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab2FZL0r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 07:26:47 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 0/2] NFC fixes for 3.5
Date: Tue, 26 Jun 2012 13:37:36 +0200
Message-Id: <1340710659-15555-1-git-send-email-sameo@linux.intel.com> (sfid-20120626_132650_761584_0417C81B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I have a couple of 3.5 fixes for NFC, one of them being a security issue.
As usual you can apply them manually or pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git for-wireless

Dan Rosenberg (1):
  NFC: Prevent multiple buffer overflows in NCI

Eric Dumazet (1):
  NFC: Return from rawsock_release when sk is NULL

 net/nfc/nci/ntf.c |   10 +++++-----
 net/nfc/rawsock.c |    5 ++++-
 2 files changed, 9 insertions(+), 6 deletions(-)

-- 
1.7.10

