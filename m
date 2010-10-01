Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54887 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab0JAPaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 11:30:09 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1P1hYm-0006E5-GN
	for linux-wireless@vger.kernel.org; Fri, 01 Oct 2010 11:30:08 -0400
Received: from linville-8530p.local (localhost.localdomain [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id o91FIa54004007
	for <linux-wireless@vger.kernel.org>; Fri, 1 Oct 2010 11:18:36 -0400
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id o91FIavf004005
	for linux-wireless@vger.kernel.org; Fri, 1 Oct 2010 11:18:36 -0400
Date: Fri, 1 Oct 2010 11:18:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: new stuff for 2.6.37 needs to be posted _now_
Message-ID: <20101001151836.GC3049@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You may have noticed that Linus has released 2.6.36-rc6.  There may
or may not be an -rc7.  So, the merge window is around the corner!

For those that need a reminder, the opening of the merge window is a
_deadline_ for new features.  Once the merge window opens, only fixes
will be accepted for 2.6.37.  In fact, any non-fix patches need to
already be in wireless-next-2.6 when the merge window opens if you want
them in 2.6.37.  That means you need to get them posted _now_, so they
can be reviewed and I can find time to merge them before the deadline.

You have been warned...this means you!

John

P.S.  I have some distractions/obligations this weekend (starting
yesterday), so my merge queue is already backed-up.  I will attempt
to get everything in my current queue merged (assuming no contrary
comments, NAKs, whatever).  Anything not already posted is in jeopardy
-- if it really needs to be in, post it ASAP and let me know it's
importance.
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
