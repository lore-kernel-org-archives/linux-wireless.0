Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mpv1.tis.cwru.edu ([129.22.105.36]:36888 "EHLO
	mpv1.tis.cwru.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbZKCANP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 19:13:15 -0500
Received: from mpv7.TIS.CWRU.edu (mpv7.tis.cwru.edu [129.22.104.170])
	by mpv1.tis.cwru.edu (MOS 4.1.8-GA)
	with ESMTP id ACE35254
	for <linux-wireless@vger.kernel.org>;
	Mon, 2 Nov 2009 19:07:18 -0500
Received: from doppelganger.local (ppp-70-225-130-224.dsl.ipltin.ameritech.net [70.225.130.224])
	by mpv7.TIS.CWRU.edu (MOS 4.1.6-GA)
	with ESMTP id HLF02472 (AUTH cws10)
	for <linux-wireless@vger.kernel.org>;
	Mon, 2 Nov 2009 19:07:17 -0500
From: CSights <csights@fastmail.fm>
To: linux-wireless@vger.kernel.org
Subject: ath5k and ".local" dropout
Date: Mon, 2 Nov 2009 19:07:16 -0500
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200911021907.16271.csights@fastmail.fm>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
	I'm having a problem with the ath5k module found in kernel 2.6.31.5 and 
accessing ".local" addresses on the network.
	What I've observed so far is that when I first boot the computer I can 
successfully access (e.g. ping) other .local computers.  If the computer with 
the ath5k card sits for a few minutes I can no longer access .local 
computers.  (Trying to ping, ping returns "ping: unknown host")  Also, other 
computers on the network can no longer ping the ath5k computer (also "ping: 
unknown host")
	Pinging the .local computers by their IP address (e.g. 192.168.1.3) does 
work.
	Access to computers "on the internet" (e.g. www.case.edu) also works.

	At first I thought this was a problem with Avahi.  Later I tried a different 
wireless card (one that uses the RT2500pci module) and there was no problem 
with the .local fading away after a few minutes.

02:04.0 Ethernet controller: Atheros Communications Inc. AR5212/AR5213 
Multiprotocol MAC/baseband processor (rev 01)                                            
        Subsystem: Compaq Computer Corporation Device 00e5                      
        Flags: medium devsel, IRQ 11                                            
        Memory at 90080000 (32-bit, non-prefetchable) [size=64K]                
        Capabilities: [44] Power Management version 2                           
        Kernel modules: ath5k

Anything else to try?  (I'm not subscribed to mailing list, so CC me in 
responses please!)

Thanks for your work!
	C.
