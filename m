Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41520 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753711AbYJIVPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 17:15:40 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: [GIT PATCH] rfkill updates
Date: Thu,  9 Oct 2008 18:15:28 -0300
Message-Id: <1223586933-17753-1-git-send-email-hmh@hmh.eng.br> (sfid-20081009_231548_093040_42FA2B34)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patchset has the current stack of changes I am comfortable enough to
propose for merging.

There is some other stuff in the burner, but since they are userspace-ABI
related and I am not sure I am happy with it yet, I want to think a bit
more before sending them to the list as an RFC patchset.

I don't really care if this patch set make it to 2.6.28 merge window or
not, they're mostly enhancements... still, I would appreciate comments
(and if they are good enough already, ACKs and maybe even a merge into
wireless-testing).

Shortlog:
Henrique de Moraes Holschuh (5):
  rfkill: use killable locks instead of interruptible
  rfkill: export global states to rfkill-input
  rfkill: add master_switch_mode and EPO lock to rfkill and rfkill-input
  rfkill: honour EPO state when resuming a rfkill controller
  rfkill: rate-limit rfkill-input workqueue usage (v3)

Thanks!

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
