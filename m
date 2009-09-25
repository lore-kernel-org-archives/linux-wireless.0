Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39033 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbZIYRpC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 13:45:02 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MrEqt-0005SI-AE
	for linux-wireless@vger.kernel.org; Fri, 25 Sep 2009 19:45:03 +0200
Received: from passportsystems.com ([68.178.128.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 19:45:03 +0200
Received: from rudicus by passportsystems.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 19:45:03 +0200
To: linux-wireless@vger.kernel.org
From: Matthew Ryan <rudicus@gmail.com>
Subject: Porting AR6K to use cfg80211
Date: Fri, 25 Sep 2009 17:40:52 +0000 (UTC)
Message-ID: <loom.20090925T193922-290@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I am using the Neo Freerunner(http://wiki.openmoko.org/wiki/Neo_FreeRunner)
on a project which I am trying to setup to use a wireless mesh network using
open80211s

I was able to build a custom kernel to enable the 80211_MESH capability, but
finally realised the driver that ships with the Freerunner isn't compatible
with the new stack.

The chipset is:

Accton (WLAN 802.11b/g SiP-M WM3236AQ(Flash Ver:2.0 Atheros AR6001GZ) which
uses the AR6K driver, which from what I have read doesn't use mac80211.

Unfortunately I know very little about wireless drivers.

I was curious if I could get a few expert opinions on if its possible to port
this driver to use mac80211, and how difficult/ what pitfalls there may be.

While I don't know much about wireless drivers, I do have extensive
experience porting other drivers and don't usually shy away from a challenge ;)
So, if there's any positive feedback I would give it a shot.

Thanks for your time and comments.

Matt Ryan

