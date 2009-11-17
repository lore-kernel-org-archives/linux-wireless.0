Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51946 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZKQOAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 09:00:25 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1NAObd-0006O4-I0
	for linux-wireless@vger.kernel.org; Tue, 17 Nov 2009 09:00:29 -0500
Received: from linville-t400.local (linville-t400.local [127.0.0.1])
	by linville-t400.local (8.14.3/8.14.3) with ESMTP id nAHDoAh9005352
	for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 08:50:10 -0500
Received: (from linville@localhost)
	by linville-t400.local (8.14.3/8.14.3/Submit) id nAHDo9Al005350
	for linux-wireless@vger.kernel.org; Tue, 17 Nov 2009 08:50:09 -0500
Date: Tue, 17 Nov 2009 08:50:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.32-rc7-git1: Reported regressions from 2.6.31 (wireless)
Message-ID: <20091117135008.GA27743@tuxdriver.com>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 16, 2009 at 11:33:23PM +0100, Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 2.6.31, for which there
> are no fixes in the mainline I know of.  If any of them have been fixed already,
> please let me know.

> Unresolved regressions
> ----------------------

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14624
> Subject		: ath9k: BUG kmalloc-8192: Poison overwritten
> Submitter	: Miles Lane <miles.lane@gmail.com>
> Date		: 2009-11-12 4:58 (5 days old)
> References	: http://marc.info/?l=linux-kernel&m=125800196520396&w=4


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14538
> Subject		: Unable to associate with AP after resume since 2.6.32-rc6
> Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> Date		: 2009-11-03 22:07 (14 days old)

 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14372
> Subject		: ath5k wireless not working after suspend-resume - eeepc
> Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
> Date		: 2009-10-03 15:36 (45 days old)
> References	: http://lkml.org/lkml/2009/10/3/91


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14352
> Subject		: WARNING: at net/mac80211/scan.c:267
> Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
> Date		: 2009-10-08 00:30 (40 days old)
> References	: http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2089#c7


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14277
> Subject		: Caught 8-bit read from freed memory in b43 driver at association
> Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> Date		: 2009-09-30 18:06 (48 days old)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
