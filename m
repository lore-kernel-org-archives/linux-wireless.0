Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from col004-omc2s3.hotmail.com ([65.55.34.77]:62853 "EHLO
	COL004-OMC2S3.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaJJN4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 09:56:55 -0400
Message-ID: <COL403-EAS377900E6B06D0233434183F3A10@phx.gbl> (sfid-20141010_155659_525090_32760918)
From: John Frankish <john.frankish@outlook.com>
To: <linux-wireless@vger.kernel.org>
Subject: Intel AC 7260 works with 64bit kernel but not 32-bit kernel
Date: Fri, 10 Oct 2014 17:45:15 +0400
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using a linux-3.16.3 64-bit kernel, the iwlwifi driver loaded with "options
iwlwifi 11n_disable=1" works most of the time. When it doesn't work, I see
the following error:

deauthenticating from c4:7d:4f:88:a9:b9 by local choice (Reason:
3=DEAUTH_LEAVING)

Using a linux-3.16.3 32-bit kernel, under the same conditions, I can never
connect, but do not see any error messages or dmesg output.

Are there any other applicable modprobe options or troubleshooting I can try
to get the 32-bit driver working?

Dmesg output below.

Intel(R) Wireless WiFi driver for Linux, in-tree:
Copyright(c) 2003- 2014 Intel Corporation
iwlwifi 0000:02:00.0: irq 63 for MSI/MSI-X
iwlwifi 0000:02:00.0: Direct firmware load failed with error -2
iwlwifi 0000:02:00.0: Falling back to user helper
iwlwifi 0000:02:00.0: loaded firmware version 25.222.9.0 op_mode iwlmvm
iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band Wireless AC 7260,
REV=0x144
iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[no dmesg output seen after here with 32-bit kernel]
wlan0: authenticate with c4:7d:4f:88:a9:b9
wlan0: send auth to c4:7d:4f:88:a9:b9 (try 1/3)
wlan0: authenticated
wlan0: associate with c4:7d:4f:88:a9:b9 (try 1/3)
wlan0: RX AssocResp from c4:7d:4f:88:a9:b9 (capab=0x431 status=0 aid=4)
wlan0: associated
