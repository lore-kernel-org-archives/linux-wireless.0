Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxgate01.infotech-enterprises.com ([203.200.218.94]:30270 "EHLO
	mxgate01.infotech-enterprises.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742Ab2BLGcJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Feb 2012 01:32:09 -0500
From: Sivakumar Pothireddy
	<Sivakumar.Pothireddy@infotech-enterprises.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Regarding RTL8191SU-GR
Date: Sun, 12 Feb 2012 06:22:23 +0000
Message-ID: <845B9439DBA52942BE709500EAB58CE002C4CDF9@INFHYDEX10MB3.corp.infotech-enterprises.com> (sfid-20120212_073238_909958_51ECE4A3)
References: <845B9439DBA52942BE709500EAB58CE002C4CD3D@INFHYDEX10MB3.corp.infotech-enterprises.com>,<845B9439DBA52942BE709500EAB58CE002C4CD9E@INFHYDEX10MB3.corp.infotech-enterprises.com>
In-Reply-To: <845B9439DBA52942BE709500EAB58CE002C4CD9E@INFHYDEX10MB3.corp.infotech-enterprises.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Dear All,
We have a Unigen device(UGWDR82NUH50) which uses RTL8191SU-GR Wi-Fi chipset.
We know that this device will work in Client mode in Linux-3.0 using the staging driver i.e. r8712u.
Our task was to make the device to run as Access point with mac80211 and nl80211.
In this regard i have few queries which are very important for us to proceed.

1) Will the same firmware used for client supports AP mode or not?
2) If it supports , does the driver code has enough calls to send the commands for AP?
3) We currently doenst have a datasheet for RTL8191SU-GR, so without having the knowledge of register set ,
can we proceed?, i mean the current driver and firmware had the commands to support AP?

It would be of great help if can look in to this and reply ASAP,

Thanks in Advance and waiting for your reply
Siva




________________________________

DISCLAIMER:

This email may contain confidential information and is intended only for the use of the specific individual(s) to which it is addressed. If you are not the intended recipient of this email, you are hereby notified that any unauthorized use, dissemination or copying of this email or the information contained in it or attached to it is strictly prohibited. If you received this message in error, please immediately notify the sender at Infotech or Mail.Admin@infotech-enterprises.com and delete the original message.
