Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43140 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab0DZTPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:15:11 -0400
Date: Mon, 26 Apr 2010 15:09:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH PING] ssb patches for SPROM location
Message-ID: <20100426190911.GH2387@tuxdriver.com>
References: <p2ub170af451004152320y64c4615ub3d7186d936cdc62@mail.gmail.com>
 <20100416133711.GB8554@tuxdriver.com>
 <m2wb170af451004160851veaed6df6r2e8ec0528f66685e@mail.gmail.com>
 <4BC88EC4.5000606@lwfinger.net>
 <20100426182655.GE2387@tuxdriver.com>
 <y2nb170af451004261133qe1e0dfaand43c190b6f7f8d3@mail.gmail.com>
 <4BD5E3A3.4050907@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4BD5E3A3.4050907@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 26, 2010 at 02:04:03PM -0500, Larry Finger wrote:
> On 04/26/2010 01:33 PM, Rafał Miłecki wrote:
> > 2010/4/26 John W. Linville <linville@tuxdriver.com>:

> >> FWIW, this patch series also still results in a hang on my problematic
> >> netbook.  I'm going to merge them anyway, in hopes that they make
> >> things better for someone (or at least get us closer to it).  I'll try
> >> to pinpoint this hang as well.
> > 
> > Did it actually pick another (newly discovered) offset for SPROM
> > location in your case? Could you add some single printk to check this?
> 
> My suggestion is that for now we only implement John's patch for no
> SPROM. I am hoping that we try to fix the failures for boxes with the
> SPROM in a normal location. Once we do that, there will be a simpler fix
> for testing at the alternate location. The patch will all be contained
> in sprom_do_read().

Hmmm...well, I just pushed (just to my public trees, not to Dave)
Rafał's trio of patches on top of mine.  Should I revert them?

John

P.S.  With those patches, this box (soon to be Larry's) still uses
an sprom_offset value of 0x1000.
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
