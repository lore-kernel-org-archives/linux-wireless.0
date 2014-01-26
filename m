Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40538 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbaAZNPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 08:15:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1W7PYG-0002ru-NB
	for linux-wireless@vger.kernel.org; Sun, 26 Jan 2014 14:15:04 +0100
Received: from p5dc2dc62.dip0.t-ipconnect.de ([93.194.220.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jan 2014 14:15:04 +0100
Received: from beweta by p5dc2dc62.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jan 2014 14:15:04 +0100
To: linux-wireless@vger.kernel.org
From: Benedikt Schwarz <beweta@gmx.com>
Subject: iwlwifi: Upload rate is ten times faster on Windows
Date: Sun, 26 Jan 2014 14:09:10 +0100
Message-ID: <lc31d9$sma$1@ger.gmane.org> (sfid-20140126_141530_101891_74A1E2D0)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

the upload rate of my Intel Centrino Wireless-N 100 BGN (REV=0x6C) with
firmware version 39.31.5.1 build 32895 is about ten times faster on
Windows 7 (~ 4500 KB/s) than on Linux (~ 500 KB/s) when uploading files
to my NAS device. I'm running Kubuntu 13.10 with kernel
3.12.0-031200-generic.

What could be the reason for this problem?


Regards,
Benedikt Schwarz


=== dmesg ===

iwlwifi 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM control
iwlwifi 0000:01:00.0: irq 44 for MSI/MSI-X
iwlwifi 0000:01:00.0: loaded firmware version 39.31.5.1 build 32895
op_mode iwldvm
iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUG disabled
iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R) Wireless-N 100 BGN,
REV=0x6C
iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:01:00.0: Radio type=0x0-0x0-0x3
iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:01:00.0: Radio type=0x0-0x0-0x3

