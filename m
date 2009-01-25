Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40643 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbZAYNYA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 08:24:00 -0500
Received: from p5b09ca39.dip.t-dialin.net ([91.9.202.57] helo=homer.local)
	by vs166246.vserver.de with esmtpa (Exim 4.63)
	(envelope-from <mb@bu3sch.de>)
	id 1LR4xz-0006Ds-8A
	for linux-wireless@vger.kernel.org; Sun, 25 Jan 2009 13:23:59 +0000
From: Michael Buesch <mb@bu3sch.de>
To: linux-wireless@vger.kernel.org
Subject: regulatory: Operation already in progress
Date: Sun, 25 Jan 2009 14:22:42 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901251422.42616.mb@bu3sch.de> (sfid-20090125_142407_966938_82BD87D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mb@quimby:~/kernel$ sudo iw reg set DE
command failed: Operation already in progress (-114)

I wonder why this happens.
What I just did was install 2.6.28.2 and install today's compat-wireless.

In dmesg I can see it succeeded once but it doesn't work anymore now.
[  973.992710] cfg80211: Calling CRDA for country: DE
[  973.998576] cfg80211: Regulatory domain changed to country: DE
[  973.998630]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  973.998691]  (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  973.998738]  (5150000 KHz - 5255000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[  973.998785]  (5470000 KHz - 5650000 KHz @ 40000 KHz), (N/A, 3000 mBm)

-- 
Greetings, Michael.
