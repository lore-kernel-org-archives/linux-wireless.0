Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46765 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbZHIR0b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 13:26:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linux-wireless@vger.kernel.org
Subject: wext channel configuration broken
Date: Sun, 9 Aug 2009 19:26:11 +0200
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200908091926.11895.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Doing an "iwconfig wlanX channel 1" on current wireless-testing _without_
doing an "iwconfig wlanX mode XXX" previously freezes the current process.
No debug messages (but I don't have manu debugging options enabled, like lock debugging).

Doing an "iwconfig wlanX mode XXX" before changing the channel fixes the issue.
This happens both on an up and down device.

-- 
Greetings, Michael.
