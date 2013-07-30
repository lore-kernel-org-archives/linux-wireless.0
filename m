Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:40380 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594Ab3G3NIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 09:08:46 -0400
Date: Tue, 30 Jul 2013 15:08:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.11] NFC fixes
Message-ID: <20130730130843.GA28677@zurbaran> (sfid-20130730_150909_126941_5740D86E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the first NFC fixes pull request for 3.11.

We only have one build failure fix for the NCI SPI transport layer
due to a missing CRC_CCITT Kconfig dependency.

Thanks in advance for pulling.

The following changes since commit 64b6f46f1141ad938e354f37af62e28da972e8eb:

  ath9k_hw: Fix multicast search for AR9002 family (2013-07-18 16:22:00 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.11-1

for you to fetch changes up to 7427b370e0aa6226c763af94fc5c4e3433383543:

  NFC: Fix NCI over SPI build (2013-07-19 16:55:26 +0200)

----------------------------------------------------------------
Frederic Danis (1):
      NFC: Fix NCI over SPI build

 net/nfc/nci/Kconfig |    1 +
 1 file changed, 1 insertion(+)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
