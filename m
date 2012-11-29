Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35636 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab2K2NOz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 08:14:55 -0500
Date: Thu, 29 Nov 2012 14:14:52 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Subject: [GIT] [NFC] 3.7 fix pull request
Message-ID: <20121129131452.GE12685@sortiz-mobl> (sfid-20121129_141458_983935_79475802)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I'm hoping it's not too late for 3.7 fixes, so here is a last minute one:

This is an NFC LLCP fix for 3.7 and contains only one patch.

It fixes a potential crash when receiving an LLCP HDLC frame acking a frame
that is not the last sent one. In that case we may dereference an already
freed pointer.


The following changes since commit 6bdd253f635f7b2ef027d116933a6c9ec148b87f:

  mac80211: fix remain-on-channel (non-)cancelling (2012-11-26 14:41:40 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git tags/nfc-fixes-3.7-2

for you to fetch changes up to 289814918ce3af1296ac7d9b05508bde64e97348:

  NFC: Fix incorrect llcp pointer dereference (2012-11-28 18:42:04 +0100)

----------------------------------------------------------------
Waldemar Rymarkiewicz (1):
      NFC: Fix incorrect llcp pointer dereference

 net/nfc/llcp/llcp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
