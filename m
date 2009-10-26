Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60567 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbZJZUBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 16:01:15 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1N2Vkm-0008Kz-04
	for linux-wireless@vger.kernel.org; Mon, 26 Oct 2009 16:01:20 -0400
Received: from linville-t400.local (linville-t400.local [127.0.0.1])
	by linville-t400.local (8.14.3/8.14.3) with ESMTP id n9QJmRhM009449
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 15:48:27 -0400
Received: (from linville@localhost)
	by linville-t400.local (8.14.3/8.14.3/Submit) id n9QJmR2A009448
	for linux-wireless@vger.kernel.org; Mon, 26 Oct 2009 15:48:27 -0400
Date: Mon, 26 Oct 2009 15:48:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: Re: 2.6.32-rc5-git3: Reported regressions 2.6.30 -> 2.6.31
Message-ID: <20091026194826.GJ2792@tuxdriver.com>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several wireless ones...

On Mon, Oct 26, 2009 at 08:26:08PM +0100, Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14417
> Subject		: [Regression] Wireless driver iwlagn+iwlcore doesn't work after resume (needs reloading)
> Submitter	: Eddy Petrișor <eddy.petrisor+linbug@gmail.com>
> Date		: 2009-10-16 11:07 (11 days old)
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14402
> Subject		: Atheros ath9k module is not working with 2.6.31.1 on an Acer Extensa 7630EZ
> Submitter	: Bernhard <berndl81@gmx.at>
> Date		: 2009-10-14 11:17 (13 days old)
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14400
> Subject		: disable/enable wlan broken with ath5k
> Submitter	: Daniel Bumke <danielbumke@gmail.com>
> Date		: 2009-10-13 12:35 (14 days old)

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14267
> Subject		: Disassociating atheros wlan
> Submitter	: Kristoffer Ericson <kristoffer.ericson@gmail.com>
> Date		: 2009-09-24 10:16 (33 days old)
> References	: http://marc.info/?l=linux-kernel&m=125378723723384&w=4

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14248
> Subject		: 2.6.31 wireless: WARNING: at net/wireless/ibss.c:34
> Submitter	: Jurriaan <thunder8@xs4all.nl>
> Date		: 2009-09-13 7:32 (44 days old)
> References	: http://marc.info/?l=linux-kernel&m=125282721113553&w=4

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14181
> Subject		: b43 causes panic at ifconfig down / shutdown
> Submitter	: Jeremy Huddleston <jeremyhu@freedesktop.org>
> Date		: 2009-09-15 18:34 (42 days old)

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14141
> Subject		: order 2 page allocation failures in iwlagn
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2009-09-06 7:40 (51 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ff05b2b4eac2e63d345fc731ea151a060247f53
> References	: http://marc.info/?l=linux-kernel&m=125222287419691&w=4
> 		  http://lkml.org/lkml/2009/10/2/86
> 		  http://lkml.org/lkml/2009/10/5/24
> 		  http://lkml.indiana.edu/hypermail/linux/kernel/0910.1/01395.html
> Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13943
> Subject		: WARNING: at net/mac80211/mlme.c:2292 with ath5k
> Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
> Date		: 2009-08-06 20:15 (82 days old)
> References	: http://marc.info/?l=linux-kernel&m=124958978600600&w=4

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
