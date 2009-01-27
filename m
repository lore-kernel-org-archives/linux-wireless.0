Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56871 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbZA0Vas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 16:30:48 -0500
Date: Tue, 27 Jan 2009 16:25:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: Bob Copeland <bcopeland@gmail.com>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Set TSF fix
Message-ID: <20090127212557.GC11849@tuxdriver.com> (sfid-20090127_223057_291196_488C184A)
References: <20090124081223.50440@gmx.net> <b6c5339f0901250841r22635bd7q40532891293a6744@mail.gmail.com> <1232901917.3837.0.camel@johannes.local> <b6c5339f0901250847i5f9f98bcl4ebec04027d7c93c@mail.gmail.com> <20090126140130.14450@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090126140130.14450@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 26, 2009 at 03:01:30PM +0100, Alina Friedrichsen wrote:
> Hello!
> 
> > > Either way, I think the changelog should back up the claim by
> > > _something_. Even if it's just "tested on device XXX, old way doesn't
> > > work, new way does" or "looked at legacy HAL code" or ...
> > 
> > Agreed, "tested on..." would be good.  I looked at the HAL and it
> > doesn't have a set tsf function, only reset.
> 
> The old code does not work on:
> AR5418+AR2122 (ath9k)
> AR5416+AR2133 (ath9k)
> 
> The new code is tested on:
> AR5418+AR2122 (ath9k)
> AR5416+AR2133 (ath9k)
> AR5001X+ (ath5k)
> AR5007EG (ath5k)
> 
> The old code was taken from:
> https://dev.openwrt.org/browser/trunk/package/madwifi/patches/383-ibss_hostap.patch
> (by Sven-Ola Tuecke)

Could you resubmit this patch with some/all of the above information
incorporated into the changelog?  I'm dropping the current version
(with limited changelog) just to avoid my own confusion.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
