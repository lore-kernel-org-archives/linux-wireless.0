Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60947 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755793AbYKCQm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 11:42:26 -0500
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: [GIT PATCH] rfkill fixes for 2.6.28-rc3
Date: Mon,  3 Nov 2008 14:42:15 -0200
Message-Id: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br> (sfid-20081103_174234_357018_7D423BEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


John, Ivo,

This small patchset contains two fixes to issues in the suspend/resume
handling of the rfkill class core.

It needs to go to 2.6.28.  These patches are based on 2.6.28-rc3.

Chances are they will *clash* with what is in wireless-testing, so I will
send a rebased patchset for wireless-testing with these patches on the
bottom of the stack (to make merging easier with mainline).

The patches are also needed on stable, but won't apply automatically.  I
don't think I will bother with 2.6.26 since the suspend/resume restore of
radio state there is not going to work well anyway, unless I backport a bit
more stuff... but 2.6.27 deserves to get them.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
