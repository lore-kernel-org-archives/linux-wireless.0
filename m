Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52177 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887AbYFWUXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 16:23:16 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Fabien Crespel <fabien@crespel.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [GIT PATCH] rfkill rework for 2.6.27 (v3)
Date: Mon, 23 Jun 2008 17:22:55 -0300
Message-Id: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br> (sfid-20080623_222326_051478_7807B2EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Here is the revised patchset, including (tested) fixes for the problems
reported by Fabien and Dmitry for the last two patches.  It includes
Fabien's patch (also tested) to rfkill-input.  Fabien sent the
signed-off-by to me privately along with a non-gmane-mangled copy of his
patch.

Dmitry, if you could look the patches dealing with rfkill-input and
either ACK them, or reply with any further issues you find, I'd
appreciate it a lot.  I have CC'ed the whole thing to you this time, so
that you can see the big picture.

Ivo, patch 11 is new.  It might benefit from either an ACK or NACK from
you.  Patch 12 has been ACKed by you previously, but you might want to
check if you still agree with it since I had to do some non-trivial
changes to it.

If there are no further comments or problems with this patchset, I'd
really like to see it sent to the -next tree...

Note that this patchset *requires* commit
5adad0133907790c50283bf03271d920d6897043 from mainline to compile, and
that commit is not available in wireless-testing's master branch.  Other
than that, the patches apply on top of wireless-testing master without
fuzz.

They're available at
http://repo.or.cz/w/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
for-upstream/rfkill

(note that the above branch was rebased on top of latest -rc, due to
the lack of commit 5adad0133907790c50283bf03271d920d6897043 in
wireless-testing).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
