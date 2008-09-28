Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:55214 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606AbYI1QiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 12:38:04 -0400
Received: from aamtaout01-winn.ispmail.ntl.com ([81.103.221.35])
          by mtaout02-winn.ispmail.ntl.com with ESMTP
          id <20080928162951.FANN21103.mtaout02-winn.ispmail.ntl.com@aamtaout01-winn.ispmail.ntl.com>
          for <linux-wireless@vger.kernel.org>;
          Sun, 28 Sep 2008 17:29:51 +0100
Received: from phoenix.fire ([86.15.232.188])
          by aamtaout01-winn.ispmail.ntl.com with ESMTP
          id <20080928162951.WLCF5827.aamtaout01-winn.ispmail.ntl.com@phoenix.fire>
          for <linux-wireless@vger.kernel.org>;
          Sun, 28 Sep 2008 17:29:51 +0100
Received: from phoenix.fire (localhost [127.0.0.1])
	by phoenix.fire (8.14.2/8.14.2) with ESMTP id m8SGY1Yq028765
	for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2008 17:34:01 +0100
Received: from localhost (localhost [[UNIX: localhost]])
	by phoenix.fire (8.14.2/8.14.2/Submit) id m8SGY1n3028764
	for linux-wireless@vger.kernel.org; Sun, 28 Sep 2008 17:34:01 +0100
From: Peter Chant <pete@petezilla.co.uk>
To: linux-wireless@vger.kernel.org
Subject: SMC wireless card, unknown Atheros/Accton chipset?
Date: Sun, 28 Sep 2008 17:34:00 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809281734.01027.pete@petezilla.co.uk> (sfid-20080928_183823_642076_231C7051)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chaps,

hope this is the right place.  I have a SMCWPCI-G2 EU wireless card (PCI) that 
does not seem to be recognised by the ath5k driver.  It is a 802.11g card but 
I tried the ath9k driver for luck, that did not work nor did the madwifi 
drivers.

Output from lspci -v:

00:0b.0 Ethernet controller: Atheros Communications Inc. Unknown device 001d 
(rev 01)
        Subsystem: Accton Technology Corporation Unknown device b203
        Flags: bus master, medium devsel, latency 32, IRQ 5
        Memory at e2010000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2


Thoughts?

Pete


-- 
Peter Chant
http://www.petezilla.co.uk
