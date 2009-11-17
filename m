Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51945 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZKQOAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 09:00:25 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1NAObd-0006O1-E4
	for linux-wireless@vger.kernel.org; Tue, 17 Nov 2009 09:00:29 -0500
Received: from linville-t400.local (linville-t400.local [127.0.0.1])
	by linville-t400.local (8.14.3/8.14.3) with ESMTP id nAHDr9RX005360
	for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 08:53:09 -0500
Received: (from linville@localhost)
	by linville-t400.local (8.14.3/8.14.3/Submit) id nAHDr9tS005358
	for linux-wireless@vger.kernel.org; Tue, 17 Nov 2009 08:53:09 -0500
Date: Tue, 17 Nov 2009 08:53:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.32-rc7-git1: Reported regressions 2.6.30 -> 2.6.31
	(wireless)
Message-ID: <20091117135308.GB27743@tuxdriver.com>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 16, 2009 at 11:58:32PM +0100, Rafael J. Wysocki wrote:
> This message contains a list of some regressions introduced between 2.6.30 and
> 2.6.31, for which there are no fixes in the mainline I know of.  If any of them
> have been fixed already, please let me know.

> Unresolved regressions
> ----------------------

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14460
> Subject		: No wireless connection with Ralink RT2500 since update to kernel 2.6.31
> Submitter	: Filipp Andjelo <andjelo@gmx.net>
> Date		: 2009-10-24 21:18 (24 days old)


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14450
> Subject		: [2.6.31] Network interfaces are dead with 2.6.31 (iwlagn and sky2)
> Submitter	: A. G. <orion.linbug@gmail.com>
> Date		: 2009-10-21 07:30 (27 days old)


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14417
> Subject		: [Regression] Wireless driver iwlagn+iwlcore doesn't work after resume (needs reloading)
> Submitter	: Eddy Petrișor <eddy.petrisor+linbug@gmail.com>
> Date		: 2009-10-16 11:07 (32 days old)


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14400
> Subject		: disable/enable wlan broken with ath5k
> Submitter	: Daniel Bumke <danielbumke@gmail.com>
> Date		: 2009-10-13 12:35 (35 days old)


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14267
> Subject		: Disassociating atheros wlan
> Submitter	: Kristoffer Ericson <kristoffer.ericson@gmail.com>
> Date		: 2009-09-24 10:16 (54 days old)
> References	: http://marc.info/?l=linux-kernel&m=125378723723384&w=4


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14181
> Subject		: b43 causes panic at ifconfig down / shutdown
> Submitter	: Jeremy Huddleston <jeremyhu@freedesktop.org>
> Date		: 2009-09-15 18:34 (63 days old)


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13943
> Subject		: WARNING: at net/mac80211/mlme.c:2292 with ath5k
> Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
> Date		: 2009-08-06 20:15 (103 days old)
> References	: http://marc.info/?l=linux-kernel&m=124958978600600&w=4

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
