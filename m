Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40713 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754524AbYHZO6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 10:58:07 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: [GIT PATCH] rfkill changes for 2.6.28, set 1a
Date: Tue, 26 Aug 2008 11:57:56 -0300
Message-Id: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br> (sfid-20080826_165814_654723_B4CD14E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is the current set of rfkill changes that I'd like to see
merged for submission in the next merge window (2.6.28).

It contains revised versions of the patches from set 1 [just the ones
that were not merged into wireless-testing yet] as per the comments
received. 

I have included Felipe Balbi's patch as well, to keep them all in one
place.  I have removed the "net: " from Felipe's patch *title* to keep
it in line with the prefix that is being used for rfkill (just
"rfkill: ").

If there are no problems with the patches and Ivo is okay with them, I'd
like to see them merged into wireless-testing.

Shortlog:

Felipe Balbi (1):
      rfkill: add missing line break

Henrique de Moraes Holschuh (3):
      rfkill: add WARN and BUG_ON paranoia (v2)
      rfkill: rename rfkill_mutex to rfkill_global_mutex
      rfkill: remove transmitter blocking on suspend

Also available for PULL from:
git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git rfkill

The patches are based on the latest wireless-testing master.

Thank you.
-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
