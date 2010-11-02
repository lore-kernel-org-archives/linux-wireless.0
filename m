Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33694 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab0KBSAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 14:00:11 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1PDL9W-0007cn-Ed
	for linux-wireless@vger.kernel.org; Tue, 02 Nov 2010 14:00:10 -0400
Received: from linville-8530p.local (localhost.localdomain [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id oA2HtTZn006936
	for <linux-wireless@vger.kernel.org>; Tue, 2 Nov 2010 13:55:30 -0400
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id oA2HtTI3006935
	for linux-wireless@vger.kernel.org; Tue, 2 Nov 2010 13:55:29 -0400
Date: Tue, 2 Nov 2010 13:55:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: tree borkage on git.kernel.org
Message-ID: <20101102175528.GC2425@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was some sort of IT hiccup on kernel.org overnight, and at
least the wireless trees (and probably others) there got restored
from several days prior.  If you cloned or pulled the wireless trees
in the last 48 hours or so, you should consider doing it again now.

In particular, you might also note that wireless-testing has been
rebased on 2.6.37-rc1...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
