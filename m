Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41834 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205AbZC0PoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:44:17 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: [GIT PATCH] rfkill updates
Date: Fri, 27 Mar 2009 12:44:07 -0300
Message-Id: <1238168651-28891-1-git-send-email-hmh@hmh.eng.br> (sfid-20090327_164420_522932_F0E97847)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While looking at the rfkill userspace API stuff that was bitrotting on
my git tree, I found this small set of minor patches for rfkill.

One of them will clash with a patch just sent to the list that removes
commented-out code.  If both patches get Ack'd, I will take care of
the clash by collecting them all in a single set and reposting the
entire set with all Acks, etc.

Please consider for inclusion in wireless-testing.  The patches are
based on wireless-testing master branch.

shortlog:

Henrique de Moraes Holschuh (4):
      rfkill: minor locking fix
      rfkill: status initialization paranoia
      rfkill: defensive use of test_bit
      rfkill: allow embedded config without an userspace API

