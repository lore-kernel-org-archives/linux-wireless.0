Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42012 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbaADXsW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jan 2014 18:48:22 -0500
Date: Sun, 5 Jan 2014 00:48:02 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.12] NFC fix
Message-ID: <20140104234802.GA10578@zurbaran> (sfid-20140105_004834_081696_8ECE4DB1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Hopefully it's not too late for a 3.12 fix for NFC. Please let me know
if it is, and I'll add it to my 3.13 pull request.

This pull request only contains one fix for a regression introduced with
commit e29a9e2ae165620d. Without this fix, we can not establish a p2p link
in target mode. Only initiator mode works.

The following changes since commit b7e047358449f8eb5cba8197b42280b676b82e54:

  Merge branch 'for-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth (2013-12-18 13:46:08 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.12-1

for you to fetch changes up to d31652a26bc9e752a99b6ac3b61353129934e451:

  NFC: Fix target mode p2p link establishment (2014-01-04 03:31:32 +0100)

----------------------------------------------------------------
Arron Wang (1):
      NFC: Fix target mode p2p link establishment

 net/nfc/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
