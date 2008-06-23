Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:60340 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779AbYFWUqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 16:46:50 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Fabien Crespel <fabien@crespel.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [GIT PATCH] rfkill rework batch 2 (new)
Date: Mon, 23 Jun 2008 17:46:41 -0300
Message-Id: <1214254004-32652-1-git-send-email-hmh@hmh.eng.br> (sfid-20080623_224654_550065_69B586E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Here are two extra patches.  I sent a RFC version of them earlier
(subject rfkill rfkill_state enhancements and new docs).

Patch 1 has been tested, some issues have been found and fixed, and now
it seems to work fine.  Patch 2 has a lot of extra documentation that
further explains how rfkill works and how to properly use it.

Please comment.  They apply on top of the "rfkill rework for 2.6.27
(v3)" batch I just sent.

Ivo, can I get an ACK for them? :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
