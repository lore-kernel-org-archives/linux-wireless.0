Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bluegene.sat.lt ([88.119.145.12]:49406 "HELO bluegene.sat.lt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757286Ab2BNWnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 17:43:37 -0500
Date: Wed, 15 Feb 2012 00:36:47 +0200
From: Nerijus Baliunas <nerijus@users.sourceforge.net>
Subject: iwl3945 cannot connect to zd1211rw AP
To: linux-wireless@vger.kernel.org
Message-ID: <Mahogany-0.68.0-758-20120215-003647.00@nerijus.sat.lt> (sfid-20120214_234339_750852_6869D1C6)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Client is Intel 3945abg and AP is ZyDAS ZD1211B (3.2.5 Fedora PAE kernel, hostapd 0.7.3).
When client is WinXP or Linux 3.0.0, I get only:
hostapd: wlan0: STA 00:18:de... IEEE 802.11: did not acknowledge authentication response
messages in AP's syslog; when client is Linux kernel 3.1.6 - no messages in AP.

Other chipsets connect to this AP successfully, and this client can connect to another
wifi stick on the same AP (rt2800usb).

Is it a iwl3945 or zd1211rw problem? How can I debug it?

Regards,
Nerijus
