Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42986 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030838Ab2CSPCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 11:02:16 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1S9e69-0005ru-A8
	for linux-wireless@vger.kernel.org; Mon, 19 Mar 2012 11:02:13 -0400
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id q2JEwRp1029673
	for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 10:58:28 -0400
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id q2JEwRIv029671
	for linux-wireless@vger.kernel.org; Mon, 19 Mar 2012 10:58:27 -0400
Date: Mon, 19 Mar 2012 10:58:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: Only fixes for 3.4 -- Re: new stuff for 3.4 needs to be posted _now_
Message-ID: <20120319145826.GA19742@tuxdriver.com> (sfid-20120319_160219_484767_70797797)
References: <20120305190508.GD18128@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120305190508.GD18128@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 05, 2012 at 02:05:08PM -0500, John W. Linville wrote:
> You may have noticed that Linus has released 3.3-rc6, and doesn't
> necessarily plan to go beyond -rc7.  So, the merge window is around
> the corner!
> 
> For those that need a reminder, the opening of the merge window is a
> _deadline_ for new features.  Once the merge window opens, only fixes
> will be accepted for 3.4.  In fact, any non-fix patches need to
> already be in wireless-next when the merge window opens if you want
> them in 3.4.  That means you need to get them posted _now_, so they
> can be reviewed and I can find time to merge them before the deadline.
> 
> You have been warned...this means you!

Linus released 3.3 yesterday (Sunday, 3/18).  The merge window for
the mainline kernel is open.

Anything not already merged in wireless-next (or wireless-testing)
will not be merged for 3.4 unless it is a fix.  If you have already
posted a fix that is not clearly marked as such, then you might send
me a reminder about it.  Otherwise, patches will have to wait for 3.5.

Merging for 3.5 will not occur after the close of the merge window
(~2 weeks from now).  Please plan accordingly.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
