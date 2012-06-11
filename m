Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49376 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab2FKNh1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 09:37:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Se4o7-0002Zg-E1
	for linux-wireless@vger.kernel.org; Mon, 11 Jun 2012 15:37:23 +0200
Received: from 194.42.38.169 ([194.42.38.169])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 15:37:23 +0200
Received: from contact by 194.42.38.169 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 15:37:23 +0200
To: linux-wireless@vger.kernel.org
From: Antonis Hadjiantonis <contact@antonis.mobi>
Subject: ath9k rate control statistics not updated for UDP
Date: Mon, 11 Jun 2012 13:37:08 +0000 (UTC)
Message-ID: <loom.20120611T152810-2@post.gmane.org> (sfid-20120611_153731_094122_050BB21D)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am using iperf to test rate control algorithms (use default:minstrel_ht) on an
ath9k device (WRT160NL OpenWRT Backfire 10.3.1 r29592). 
When I use UDP traffic over an 802.11g connection, the rcstat file is not
updated. Not sure if the rate control algoritmh works during the process.
If I use TCP traffic, rcstat is updated and statistics/rate change accordingly.

Is this the correct behaviour of minstrel RC? I went through documentation
regarding MRR and retransmission bounds but wasn't able to figure it out. Any
one noticed something similar?

Thanks in advance,
Antonis

