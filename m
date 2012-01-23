Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4951 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab2AWRP6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 12:15:58 -0500
To: ben@decadent.org.uk
Subject: linux-firmware pull request
Cc: linux-wireless@vger.kernel.org
Message-Id: <20120123170745.314D4207D2@salmon.rtg.net> (sfid-20120123_181602_208127_D170E6B9)
Date: Mon, 23 Jan 2012 10:07:45 -0700 (MST)
From: timg@tpi.com (Tim Gardner)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit a2995d38c234e3d767df7223d84a0f33a1a24997:

  firmware/isci: update to oem parameter format v1.3 (2012-01-05 13:21:40 +0000)

are available in the git repository at:
  git://kernel.ubuntu.com/rtg/linux-firmware.git iwlwifi

Tim Gardner (5):
      iwlwifi: add new firmware for 105 devices
      iwlwifi: add new firmware for 135 devcies
      iwlwifi: add new firmware for 2000 devices
      iwlwifi: add new firmware for 2030 devices
      iwlwifi: add new firmware for 6000g2b devices

 WHENCE                  |   15 +++++++++++++++
 iwlwifi-105-6.ucode     |  Bin 0 -> 689680 bytes
 iwlwifi-135-6.ucode     |  Bin 0 -> 701228 bytes
 iwlwifi-2000-6.ucode    |  Bin 0 -> 695876 bytes
 iwlwifi-2030-6.ucode    |  Bin 0 -> 707392 bytes
 iwlwifi-6000g2b-6.ucode |  Bin 0 -> 679436 bytes
 6 files changed, 15 insertions(+), 0 deletions(-)
 create mode 100644 iwlwifi-105-6.ucode
 create mode 100644 iwlwifi-135-6.ucode
 create mode 100644 iwlwifi-2000-6.ucode
 create mode 100644 iwlwifi-2030-6.ucode
 create mode 100644 iwlwifi-6000g2b-6.ucode
