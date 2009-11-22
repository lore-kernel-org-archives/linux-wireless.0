Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:38303 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbZKVM22 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2009 07:28:28 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NCBYO-0000dR-0j
	for linux-wireless@vger.kernel.org; Sun, 22 Nov 2009 13:28:32 +0100
Received: from lister.visitors.farnz.org.uk ([81.187.250.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2009 13:28:31 +0100
Received: from simon by lister.visitors.farnz.org.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2009 13:28:31 +0100
To: linux-wireless@vger.kernel.org
From: Simon Farnsworth <simon@farnz.org.uk>
Subject: HTC Hero cannot get an address from an ath5k AP
Date: Sun, 22 Nov 2009 12:28:03 +0000
Message-ID: <hebaok$2ip$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've recently acquired a HTC Hero, and thought I'd try and use it with my 
ath5k based AP. It doesn't work, and I'm at a loss to debug it.

The only hint I have is that neither of my (Linux-based) laptops can hold 
association to the AP without traffic flowing continuously, which leads me 
to suspect power saving issues.

My hostapd configuration file is attached; I've checked that I've used the 
correct WEP key. I can provide any more information that's needed. My 
controller appears in lspci as:

02:04.0 Ethernet controller [0200]: Atheros Communications Inc. 
AR5212/AR5213 Multiprotocol MAC/baseband processor [168c:0013] (rev 01)

and in dmesg as:

[572338.589520] ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)

I have:

CONFIG_ATH_COMMON=m
CONFIG_ATH_DEBUG=y
CONFIG_ATH5K=m
CONFIG_ATH5K_DEBUG=y

set in my .config, and have debugfs available.
-- 
Any help will be gratefully received,

Simon Farnsworth

