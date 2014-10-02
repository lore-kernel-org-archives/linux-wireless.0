Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41258 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaJBTAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 15:00:14 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1XZlbl-0003HB-8f
	for linux-wireless@vger.kernel.org; Thu, 02 Oct 2014 15:00:09 -0400
Received: from linville-x1.hq.tuxdriver.com (localhost.localdomain [127.0.0.1])
	by linville-x1.hq.tuxdriver.com (8.14.8/8.14.6) with ESMTP id s92IqwqZ032383
	for <linux-wireless@vger.kernel.org>; Thu, 2 Oct 2014 14:52:59 -0400
Received: (from linville@localhost)
	by linville-x1.hq.tuxdriver.com (8.14.8/8.14.8/Submit) id s92Iqwfu032382
	for linux-wireless@vger.kernel.org; Thu, 2 Oct 2014 14:52:58 -0400
Date: Thu, 2 Oct 2014 14:52:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: new stuff for 3.18 needs to be posted _now_
Message-ID: <20141002185258.GE12208@tuxdriver.com> (sfid-20141002_210019_067004_D42A4012)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You may have noticed that Linus has released 3.17-rc7.  So, the merge
window for 3.18 is around the corner!

For those that need a reminder, the opening of the merge window is
a _deadline_ for new features.  Once the merge window opens, only
fixes will be accepted for 3.18.  In fact, any non-fix patches need to
already be in wireless-next when the merge window opens if you want
them in 3.18.  That means you need to get them posted _now_, so they
can be reviewed and I can find time to merge them before the deadline.

In fact, at this point I'm can't be sure that I will have enough
time to merge anything else in time for the window.  Linus has been
a bit unclear about how this merge window will be handled, so YMMV --
we may have to play this one by ear...

You have been warned...this means you!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
