Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763942AbXF2NeK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 09:34:10 -0400
From: Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH 0/5] airo fixes (take 3)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Matteo Croce <rootkit85@yahoo.it>
Date: Fri, 29 Jun 2007 15:33:25 +0200
Message-ID: <20070629131841.6658.76381.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

here are some fixes for the airo driver:

airo: disable the PCI device when unloading module
airo: delay some initialization until the netdev is up
airo: fix a race causing initialization failures
airo: simpler calling convention for enable_MAC()
airo: start with radio off

I don't think my "take 2" series ever made it to the list or to any of you. I
had some email problems. That series did not include the last patch, because
Matteo Croce reported problems with it. I believe I fixed it now.

Special note for Matteo:
 You had a problem applying patches included in email bodies instead of
 attachments...
 I see that you are using KMail. I believe in KMail you can right-click on a
 message, choose "Save As..." and save the whole email in mbox format and treat
 the resulting file as a patch. The patch program should be clever enough to
 ignore the text preceding the patch itself.

Michal

