Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62220 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab3DKLKc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:10:32 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	"Linux NFC" <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [RFC] [PATCH 0/2 v2] NFC RFKILL support
Date: Thu, 11 Apr 2013 13:09:20 +0200
Message-Id: <1365678562-5583-1-git-send-email-sameo@linux.intel.com> (sfid-20130411_131035_928361_FC7FDDA1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a RFC for adding RFKILL support to NFC>
As I said in v1, I'd like to pass this one through my next NFC pull request,
I'm looking for Johannes and/or Marcel ACKs before doing so.

v2:
	* Split the initial patch into 2: One for the core rfkill parts,
	  another one for the NFC bits.
	* Added a comment line for RFKILL_TYPE_NFC in rfkill.h

Samuel Ortiz (2):
  rfkill: Add NFC to the list of supported radios
  NFC: RFKILL support

 include/net/nfc/nfc.h       |    2 ++
 include/uapi/linux/rfkill.h |    2 ++
 net/nfc/core.c              |   38 ++++++++++++++++++++++++++++++++++++++
 net/rfkill/core.c           |    4 +++-
 4 files changed, 45 insertions(+), 1 deletion(-)

-- 
1.7.10.4

