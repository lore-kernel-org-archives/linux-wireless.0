Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:51517
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXERRjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 13:39:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
Subject: bcm43xx-mac80211 freezes on heavy RX
Date: Fri, 18 May 2007 19:38:36 +0200
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200705181938.36503.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am seeing freezes when doing heavy RX with
bcm43xx-mac80211. It triggers when continuously
downloading some file with wget from a machine in
the network over the wireless link.

I'm not sure what causes the freeze. Does someone see
this with other devices on the mac80211 stack?
It simply completely freezes the whole system.
No message, nothing. Very strange.

I'm using my development tree.

-- 
Greetings Michael.
