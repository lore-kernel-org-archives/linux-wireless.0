Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s38.bay0.hotmail.com ([65.54.246.238]:11709 "EHLO
	bay0-omc3-s38.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753885AbYA3MyT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 07:54:19 -0500
Message-ID: <BAY129-W3322851BBFB99D8B0467CCCB360@phx.gbl> (sfid-20080130_125429_794593_EBF4A51C)
From: Adrian Bassett <adrian.bassett@hotmail.co.uk>
To: <linux-wireless@vger.kernel.org>
Subject: Problem with rtl8180 driver and git kernel
 be338637e83b2ae335d68a271a13d77b570931fe
Date: Wed, 30 Jan 2008 12:54:19 +0000
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I have pulled the most recent wireless git kernel (tag as per Subject:) and find that the rtl8180 driver or, more probably, something that it depends on, is causing a kernel panic.

Initially, I got the following (manually transcribed) diagnostic:

Unable to handle kernel NULL pointer dereference at 0000000000000006 RIP:
[] :rtl8180:rtl8180_tx+0x6d/0x23e
PGD 79816067 PUD 79878067 PMD 0
Oops: 0000 [1]

On subsequent hung reboots I am getting rather more output but am still pondering how to trap that :-(

However, some of the diagnostic seems to implicate (IIRC) ieee80211_sta_scan_work so it may be that recent
changes as described at http://article.gmane.org/gmane.linux.kernel.wireless.general/10730 are not working in 
this instance.

This is on an x86_64 SMP system.  Please request any additional information that might be useful.

Adrian Bassett

_________________________________________________________________
Share what Santa brought you
https://www.mycooluncool.com