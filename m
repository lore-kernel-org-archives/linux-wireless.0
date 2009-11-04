Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:56418 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbZKDAtZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 19:49:25 -0500
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [announce] new rt2800 drivers for Ralink wireless & project tree
Date: Wed, 4 Nov 2009 01:48:08 +0100
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Randy Dunlap <rdunlap@xenotime.net>,
	Luis Correia <luis.f.correia@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ingo Molnar <mingo@elte.hu>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jarek Poplawski <jarkao2@gmail.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	David Miller <davem@davemloft.net>
References: <200911031951.05235.bzolnier@gmail.com> <200911040052.28323.bzolnier@gmail.com> <20091104004015.23c4c1a3@lxorguk.ukuu.org.uk>
In-Reply-To: <20091104004015.23c4c1a3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911040148.08787.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 November 2009 01:40:15 Alan Cox wrote:
> On Wed, 4 Nov 2009 00:52:28 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > On Wednesday 04 November 2009 00:48:35 Alan Cox wrote:
> > > > > Yeah I know that. But like I said, I still needed to get around to do that,
> > > > > and I am very happy you were interested in fixing it.
> > > > 
> > > > Lets make one thing clear: YOU SHOULD BE THE ONE FIXING IT.
> > > 
> > > Really - you have a service and support contract with Ivo.. no i thought
> > > not.
> > 
> > Just today I got PM from somebody complaining to me about non-working
> > pata_pdc2026x_old (pdc202xx_old works fine for him) simply because
> > I fixed some bug there some time ago....
> 
> And didn't bother committing a patch to both sets of code bec

You misread my mail.

Because I also fixed bug in the PATA code though I was IDE Maintainer.

Also:

Did you have a service & support contract with me when you were complaining
about IDE to me?  [ and I would strongly suggest you not to go there.. ]

Or reversing the initial question:

Does Ivo have a contract with me to contribute to rt2x00 project?

So please stop idiotic arguments.

-- 
Bartlomiej Zolnierkiewicz
