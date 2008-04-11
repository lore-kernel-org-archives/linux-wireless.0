Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45535 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYDKPP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2008 11:15:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: mac80211: Spinlock recursion on resume
Date: Fri, 11 Apr 2008 17:13:44 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804111713.44732.mb@bu3sch.de> (sfid-20080411_161534_337385_54F4BA98)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I had the following spinlock recursion lockup
when resuming from suspend:
http://bu3sch.de/misc/recursion.jpg

Dunno what causes this, but it looks like it could easily
be spotted by someone who knows the code :)

-- 
Greetings Michael.
