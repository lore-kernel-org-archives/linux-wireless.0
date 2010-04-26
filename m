Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38505 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab0DZVPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 17:15:13 -0400
Date: Mon, 26 Apr 2010 17:03:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH PING] ssb patches for SPROM location
Message-ID: <20100426210349.GA23289@tuxdriver.com>
References: <p2ub170af451004152320y64c4615ub3d7186d936cdc62@mail.gmail.com>
 <20100416133711.GB8554@tuxdriver.com>
 <m2wb170af451004160851veaed6df6r2e8ec0528f66685e@mail.gmail.com>
 <4BC88EC4.5000606@lwfinger.net>
 <20100426182655.GE2387@tuxdriver.com>
 <y2nb170af451004261133qe1e0dfaand43c190b6f7f8d3@mail.gmail.com>
 <4BD5E3A3.4050907@lwfinger.net>
 <20100426190911.GH2387@tuxdriver.com>
 <h2vb170af451004261249k43377e65n9d85f6dc7c377e67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <h2vb170af451004261249k43377e65n9d85f6dc7c377e67@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 26, 2010 at 09:49:02PM +0200, Rafał Miłecki wrote:
> 2010/4/26 John W. Linville <linville@tuxdriver.com>:

> > P.S.  With those patches, this box (soon to be Larry's) still uses
> > an sprom_offset value of 0x1000.
> 
> Hm, so it looks like you device doesn't match our "if (version)"
> condition... It's just a blind guess, but maybe it would be worth to
> *force* other SPROM location on your machine? It seems quite proven
> that reading some incorrect registers (in this case incorrect SPROM
> location) can cause lock up. Of course it's just my guess, assuming
> you have other SPROM location, lock up is caused by reading wrong
> register and that Larry's condition in incorrect/not full. However if
> you're gonna to send whole machine to Larry, it sounds worthy to check
> this trick.

Well I thought I had done that before, but apparently not.  I forced
sprom_offset to 0x0800 and ssb and b43 both load and act like they
are working.  OTOH, b43 doesn't seem to be passing traffic but I may
just not have the right firmware...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
