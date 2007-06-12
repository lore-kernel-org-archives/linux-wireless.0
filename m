Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2964 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbXFLBYb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 21:24:31 -0400
Received: from ra.tuxdriver.com (ra.tuxdriver.com [127.0.0.1])
	by ra.tuxdriver.com (8.14.0/8.13.7) with ESMTP id l5C1OMdY029481
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2007 21:24:28 -0400
Received: (from uucp@localhost)
	by ra.tuxdriver.com (8.14.0/8.14.0/Submit) with UUCP id l5C1FU7X029227
	for linux-wireless@vger.kernel.org; Mon, 11 Jun 2007 21:15:30 -0400
Received: from linville-t43.mobile (linville-t43.mobile [127.0.0.1])
	by linville-t43.mobile (8.13.8/8.13.8) with ESMTP id l5C165Pe023312
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2007 21:06:05 -0400
Received: (from linville@localhost)
	by linville-t43.mobile (8.13.8/8.13.8/Submit) id l5C165ZU023311
	for linux-wireless@vger.kernel.org; Mon, 11 Jun 2007 21:06:05 -0400
Date: Mon, 11 Jun 2007 21:06:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: changes in wireless-2.6 tree
Message-ID: <20070612010605.GB20422@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a heads-up on some wireless-2.6 tree changes...

I'm dropping the following branches:

	adm8211
	prism54usb
	tiacx

All of them will be available here for now:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-legacy.git

I don't know how many people actually are interested in these.
The first two have mac80211-based alternatives already in wireless-dev,
and an out-of-tree mac80211-based alternative exists for tiacx as well.
Anyway, none of the new wireless-legacy drivers will ever go upstream,
so I see no more point in maintaining them in wireless-2.6 any longer.

Also, I have traditionally used the wireless-2.6 "master" branch as
a collection branch which pulled from all the other branches (and was
constantly rebased).  I will now use an "everything" branch for that
purpose and leave my "master" branch as a vanilla pull from Linus --
this seems to be the more canonical usage pattern.

There are a number of other branches as well -- most of these are there
for administrative purposes and can be safely ignored by most users.

Anyway, FYI...

John
-- 
John W. Linville
linville@tuxdriver.com
