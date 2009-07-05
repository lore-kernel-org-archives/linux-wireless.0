Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([204.127.217.105]:33737 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbZGEV60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 17:58:26 -0400
Message-ID: <4A51220C.5000101@lwfinger.net>
Date: Sun, 05 Jul 2009 16:58:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John W Linville <linville@tuxdriver.com>
CC: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43/b43legacy: Fix condition in which radio LED did not
 initialize correctly, and remove 4 compilation warnings
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> After the recent changes in rfkill, the radio LED used by
> b43/b43legacy
> did not always initialize correctly.

> Both b43 and b43legacy used the deprecated variable radio_enabled in
> struct ieee80211_conf.

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>


John,

I have decided to push the LED failure to initialize as a regression
in 2.6.31-rcX. Is there a problem with this patch that has kept it
from being included in wireless-testing?

Larry
