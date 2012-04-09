Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39280 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456Ab2DIVRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 17:17:23 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1SHLxg-0000hT-2s
	for linux-wireless@vger.kernel.org; Mon, 09 Apr 2012 17:17:20 -0400
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id q39L62xS018380
	for <linux-wireless@vger.kernel.org>; Mon, 9 Apr 2012 17:06:02 -0400
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id q39L61vL018372
	for linux-wireless@vger.kernel.org; Mon, 9 Apr 2012 17:06:01 -0400
Date: Mon, 9 Apr 2012 17:06:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: wireless-testing rebased on top of 3.4-rc2
Message-ID: <20120409210600.GC26994@tuxdriver.com> (sfid-20120409_231731_167434_F90090F4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings,

Just FYI, the wireless-testing tree has been rebased on top of 3.4-rc2.
This tree gets rebased from time to time, particularly after a new
release.  It's purpose is just to be a place to integrate and test
current wireless patches on top of a somewhat-recent base from Linus
(usually the latest -rcX).  Linus doesn't pull from this tree either
directly or indirectly, so it isn't necessary to preserve its history.
The rebasing does, however, simplify bisections when they become
necessary.

I have also started merging bits for 3.5 in the wireless-next tree
(which feeds wireless-testing).  I was at LF's Collaboration Summit
last week, so I am a bit behind on the merging.  I hope to catch-up
over the next few days.  I apologize for any inconvenience in the
meantime.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
