Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36052 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab2EICqU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 22:46:20 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1SRwux-0002As-IO
	for linux-wireless@vger.kernel.org; Tue, 08 May 2012 22:46:19 -0400
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id q492d7ls011269
	for <linux-wireless@vger.kernel.org>; Tue, 8 May 2012 22:39:07 -0400
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id q492d79s011268
	for linux-wireless@vger.kernel.org; Tue, 8 May 2012 22:39:07 -0400
Date: Tue, 8 May 2012 22:39:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: new stuff for 3.4 needs to be posted _now_
Message-ID: <20120509023907.GB2533@tuxdriver.com> (sfid-20120509_044655_421555_68F60494)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You may have noticed that Linus has released 3.4-rc6, and "we're
getting close to final 3.4".  So, the merge window is around the
corner!

For those that need a reminder, the opening of the merge window is
a _deadline_ for new features.  Once the merge window opens, only
fixes will be accepted for 3.5.  In fact, any non-fix patches need to
already be in wireless-next when the merge window opens if you want
them in 3.5.  That means you need to get them posted _now_, so they
can be reviewed and I can find time to merge them before the deadline.

You have been warned...this means you!

John

P.S.  A combination of personal and business commitments and the
recent kerfuffle regarding bluetooth patches have conspired against my
normal merging duties and habits.  I will do what I can to get back
on track, but if Linus does not release an -rc7 then there is a very
good chance that anything not already merged in wireless-next will not
make it for the 3.5 merge window.  I apologize for the inconvenience,
but please do plan accordingly.
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

