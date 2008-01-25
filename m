Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3136 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760204AbYAYTDS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 14:03:18 -0500
Date: Fri, 25 Jan 2008 13:34:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080125183455.GC14687@tuxdriver.com> (sfid-20080125_190323_458934_47E302FD)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801251723.58891.mb@bu3sch.de> <alpine.LFD.1.00.0801250841080.14161@hp.linux-foundation.org> <200801251921.48862.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200801251921.48862.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2008 at 07:21:48PM +0100, Michael Buesch wrote:

> So why remove
> a sanity check that tells you about bugs in other drivers where it does
> matter (because they are used on such weird architectures), just because one
> vendor says "hey, doesn't matter for me"?

This is a good point.  If people were already using a driver on an
oddball architecture, then we would get _those_ warnings (as we did
when someone plugged a zd1211 device into their sparc box).  The point
of the warning is/was to point-out the problem to developers running
on mainstream architecutres so that they could fix these problems
rather than foisting them on some poor schmuck years from now trying
to build an SPARC-based AP.  (Hey, it could happen...)

John
-- 
John W. Linville
linville@tuxdriver.com
