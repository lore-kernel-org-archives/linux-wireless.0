Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58398 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZHJPQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 11:16:07 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1MaWbX-0007bA-J0
	for linux-wireless@vger.kernel.org; Mon, 10 Aug 2009 11:16:07 -0400
Received: from linville-t400.local (linville-t400.local [127.0.0.1])
	by linville-t400.local (8.14.3/8.14.3) with ESMTP id n7AF4tVn003565
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 11:04:55 -0400
Received: (from linville@localhost)
	by linville-t400.local (8.14.3/8.14.3/Submit) id n7AF4tlB003563
	for linux-wireless@vger.kernel.org; Mon, 10 Aug 2009 11:04:55 -0400
Date: Mon, 10 Aug 2009 11:04:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: wireless regressions -- Re: 2.6.31-rc5-git5: Reported regressions
	from 2.6.30
Message-ID: <20090810150455.GB2733@tuxdriver.com>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 09, 2009 at 10:36:49PM +0200, Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 2.6.30, for which there
> are no fixes in the mainline I know of.  If any of them have been fixed already,
> please let me know.

Wireless-related ones...

> Unresolved regressions
> ----------------------

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13947
> Subject		: Libertas: Association request to the driver failed
> Submitter	: Daniel Mack <daniel@caiaq.de>
> Date		: 2009-08-07 19:11 (3 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=57921c312e8cef72ba35a4cfe870b376da0b1b87
> References	: http://marc.info/?l=linux-kernel&m=124967234311481&w=4
> Handled-By	: Roel Kluin <roel.kluin@gmail.com>
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13943
> Subject		: WARNING: at net/mac80211/mlme.c:2292 with ath5k
> Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
> Date		: 2009-08-06 20:15 (4 days old)
> References	: http://marc.info/?l=linux-kernel&m=124958978600600&w=4
 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13940
> Subject		: iwlagn and sky2 stopped working, ACPI-related
> Submitter	: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
> Date		: 2009-08-07 22:33 (3 days old)
> References	: http://marc.info/?l=linux-kernel&m=124968457731107&w=4
 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13848
> Subject		: iwlwifi (4965) regression since 2.6.30
> Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
> Date		: 2009-07-26 7:57 (15 days old)
> References	: http://marc.info/?l=linux-kernel&m=124859658502866&w=4
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13846
> Subject		: LEDs switched off permanently by power saving with rt61pci driver
> Submitter	: Chris Clayton <chris2553@googlemail.com>
> Date		: 2009-07-13 8:27 (28 days old)
> References	: http://marc.info/?l=linux-kernel&m=124747418828398&w=4
 
> Regressions with patches
> ------------------------
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13948
> Subject		: ath5k broken after suspend-to-ram
> Submitter	: Johannes Stezenbach <js@sig21.net>
> Date		: 2009-08-07 21:51 (3 days old)
> References	: http://marc.info/?l=linux-kernel&m=124968192727854&w=4
> Handled-By	: Nick Kossifidis <mickflemm@gmail.com>
> Patch		: http://patchwork.kernel.org/patch/38550/
 
Hth...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
