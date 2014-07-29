Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay004-omc2s17.hotmail.com ([65.54.190.92]:57780 "EHLO
	BAY004-OMC2S17.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114AbaG2H2E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 03:28:04 -0400
Message-ID: <BAY178-W38CA42DFDD4031D453FB48CFF80@phx.gbl> (sfid-20140729_092818_693088_08D85386)
From: Borislav Boev <borislavboev@hotmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Poor wifi performance on Intel 7260 Dual-Band AC Wifi card
Date: Tue, 29 Jul 2014 10:28:03 +0300
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, I am reporting this bug, though it is well known for years. In general I've experienced poor wifi performance with all Intel cards, starting from 3945abg, 4965agn and now Intel 7260 Dual-Band AC.
The old cards were on a ThinkPad T61 system, 7260 is on a brand new ThinkPad Edge E540.

So here's the problem:
Wireless conection is slow, there's a unusual ping while browsing web pages (tried with all browsers - no luck), and sometimes drop-outs in connection.
There's a partial fix by disabling Wireless "N" mode, but this is irrational, because it limits the network to only 54mbits speed.

Details about the system:
Hardware:
ThinkPad E540
CPU: Intel core i5-4200m (Haswell)
Wireless adapter: Intel 7260 Dual-Band AC

Software:
PCLinuxOS 2014.07
Kernel: 3.15.5 (though it was the same with old kernels)
Kernel module: iwlwifi 
 		 	   		  