Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:33015 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760294AbZAQXVE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2009 18:21:04 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LOKTJ-0005vM-Q3
	for linux-wireless@vger.kernel.org; Sat, 17 Jan 2009 23:20:57 +0000
Received: from 77-21-172-36-dynip.superkabel.de ([77.21.172.36])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 17 Jan 2009 23:20:57 +0000
Received: from feldmann_markus by 77-21-172-36-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 17 Jan 2009 23:20:57 +0000
To: linux-wireless@vger.kernel.org
From: feldmaus <feldmann_markus@gmx.de>
Subject: Does ACPIPHP work on my Machine
Date: Sun, 18 Jan 2009 00:20:48 +0100
Message-ID: <gktp4e$p6h$1@ger.gmane.org> (sfid-20090118_002111_030683_7460678C)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matthew Garrett,

so i went home to read what you want from me to test.
The Directory </sys/bus/pci/slots/> is empty.
Si there something else i can test ?

I give you some more Information.
wes-nic:/sys/bus/pci/slots# lspci -d 14e4:4301 -vv
02:02.0 Network controller: Broadcom Corporation BCM4303 802.11b 
Wireless LAN Controller (rev 02)
	Subsystem: Hewlett-Packard Company Device 12f3
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+ <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at e0104000 (32-bit, non-prefetchable) [size=8K]
	Kernel driver in use: b43-pci-bridge
	Kernel modules: ssb


Regards Markus

