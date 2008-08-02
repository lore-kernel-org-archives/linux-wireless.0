Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59091 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbYHBR4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 13:56:31 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: [GIT PATCH] rfkill fixes, set 3
Date: Sat,  2 Aug 2008 14:56:24 -0300
Message-Id: <1217699786-20672-1-git-send-email-hmh@hmh.eng.br> (sfid-20080802_195635_575515_4D731EEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is a small set of two patches that fix issues in current rfkill.

If Ivo acks them, please merge on wireless-testing, and after a small
while, please consider sending them to mainline for 2.6.27-rc merging.

Henrique de Moraes Holschuh (2):
      rfkill: protect suspended rfkill controllers
      rfkill: use strict_strtoul

Thanks!

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
