Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vpn.innerrange.com.au ([203.122.143.146]:41588 "EHLO
	remote.innerrange.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750787AbcFCG2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 02:28:14 -0400
From: Craig McQueen <craig.mcqueen@innerrange.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 3 Jun 2016 16:28:06 +1000
Subject: rt2800usb firmware rt2870.bin 0.36 not scanning
Message-ID: <5500469A22567C4BAF673A6E86AFA3A4022D2A096260@IR-CENTRAL.corp.innerrange.com> (sfid-20160603_083536_474548_51F5A9F1)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a D-Link DWA-140 USB Wi-Fi device which is rt2800 based (5392 chipset). I'm trying to use it on a BeagleBone Black based system with 3.14.x kernel built with Yocto. We're using ConnMan 1.30 at the moment.

We've been finding some instabilities with it periodically disconnecting from some networks. So we tried upgrading the firmware file rt2870.bin from version 0.29 to 0.36. That seems to be more stable with the network. However, we're finding that it initially doesn't connect, until the Wi-Fi has been disabled and then re-enabled. 'connmanctl scan wifi' and 'iwlist scan' don't return anything until Wi-Fi has been disabled and then re-enabled.

Have there been any Linux driver changes needed to support this 0.36 firmware? Does anyone have any pointers on where to look to understand this behaviour between 0.29 and 0.36 firmware?

-- 
Craig McQueen

