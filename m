Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3261 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934177AbXCVSOb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2007 14:14:31 -0400
Date: Thu, 22 Mar 2007 13:47:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: rt2400-devel@lists.sourceforge.net
Cc: linux-wireless@vger.kernel.org
Subject: bug in rt2x00debug_deregister?
Message-ID: <20070322174731.GG3860@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=233345
http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=233434

Seeing some oopsen w/ the rt2x00 driver currently in Fedora rawhide.
That version does not have the most recent round of patches I merged
to wireless-dev a couple of days ago, FWIW.

I think it would be great if Ivo or some other rt2x00 developers
would register in Red Hat's bugzilla so that I can CC: them on bugs --
please let me know if anyone is amenable to that.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
