Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59848 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787AbYGVAS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 20:18:28 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: [GIT PATCH] rfkill fixes, set 2, v2
Date: Mon, 21 Jul 2008 21:18:16 -0300
Message-Id: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br> (sfid-20080722_021833_207856_71CAB8D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Here is the updated version, with all requested corrections.

Ivo, please check if they're as you wanted in the patches still missing
your acked-by (patches 3, 5).

There is one extra minor doc-fix patch, patch 6.  I found I somehow sent
an older version for merge (d3d682041a15f69cd335172041a8393e878521e9
"rfkill: some minor kernel-doc changes for rfkill_toggle_radio"), and
since I had the fix lying around...

Henrique de Moraes Holschuh (6):
      rfkill: document rfkill_force_state as required (v2)
      rfkill: fix led-trigger unregister order in error unwind
      rfkill: document the rfkill struct locking (v2)
      rfkill: mutex fixes
      rfkill: query EV_SW states when rfkill-input (re)?connects to a input device
      rfkill: yet more minor kernel-doc fixes

Please consider for merging for 2.6.27-rc1, as they are fixes and not
enhancements.

Patches based on wireless-testing master.                                                                                                            

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
