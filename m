Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40752 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab3CFWpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 17:45:25 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1UDN5O-0002uX-RJ
	for linux-wireless@vger.kernel.org; Wed, 06 Mar 2013 17:45:22 -0500
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.5/8.14.4) with ESMTP id r26Mi246013894
	for <linux-wireless@vger.kernel.org>; Wed, 6 Mar 2013 17:44:03 -0500
Received: (from linville@localhost)
	by linville-8530p.local (8.14.5/8.14.5/Submit) id r26Mi2cL013893
	for linux-wireless@vger.kernel.org; Wed, 6 Mar 2013 17:44:02 -0500
Date: Wed, 6 Mar 2013 17:44:01 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: wireless-testing rebased on 3.9-rc1
Message-ID: <20130306224401.GA20300@tuxdriver.com> (sfid-20130306_234530_359274_257C42DB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that the merge window is closed and things are progressing towards
3.9, I have rebased the wireless-testing tree upon 3.9-rc1.  It won't
stay clean for long, of course -- it will pull from the wireless and
wireless-next trees continually and will pull from the linux tree
after each -rc release, as usual.

The current head of the tree is commit 12c18c7a3d8f20366424834b20be40f7f3a9e2c2.
Please adjust your development trees accordingly.

John

P.S.  Note that this has no effect on trees used to push changes
through me towards Dave and Linus.  The wireless and wireless-next
trees have merely been fast-forwarded.
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
