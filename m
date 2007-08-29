Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:55358 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbXH2Tdp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 15:33:45 -0400
Received: by wa-out-1112.google.com with SMTP id v27so322637wah
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2007 12:33:45 -0700 (PDT)
Message-ID: <9e4733910708291233h3c4022a9n6e46733c5c50e222@mail.gmail.com>
Date: Wed, 29 Aug 2007 15:33:43 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/5] Net: ath5k, license is GPLv2
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
	"Christoph Hellwig" <hch@infradead.org>,
	"Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20070829192858.75aa6542@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <2713029743177393055@pripojeni.net>
	 <7515194658758617@pripojeni.net>
	 <20070828171155.GC29343@infradead.org>
	 <3208.1188408545@turing-police.cc.vt.edu>
	 <9e4733910708291101i3783a8b1l38f0d5cfb0c2863d@mail.gmail.com>
	 <20070829192858.75aa6542@the-village.bc.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/29/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > to remove the BSD/other license.   Jiri can release *his* code as GPLv2
> > > only, but I suspect the files as a whole really should be dual BSD/GPLv2,
> > > due to the numerous other stakeholders in those files.
> >
> > This mess has been occurring in the kernel for years. The DRM graphics
> > drivers are used in both BSD and Linux. It is quite easy to contribute
> > something to this code via LKML and think you are doing it under the
> > GPL. Doesn't a patch against the kernel have to be GPL? When these
> > patches get pulled back into BSD and distributed with it, did BSD get
> > infected with the GPL? AFAIK this has never been legally sorted out.
>
> I'm not aware anyone has felt it needed "sorting out". Its not exactly
> complicated.
>
>         BSD non advertising is compatible with GPL
>
> The GPL says:
>         "when you distribute the same sections as part of a whole which
>         is a work based on the Program, the distribution of the whole
>         must be on the terms of this License, "
>
> The BSD license doesn't conflict with that
>
> The GPL (and copyright law also say)
>
> "If identifiable sections of that work are not derived from the Program,
> and can be reasonably considered independent and separate works in
> themselves, then this License, and its terms, do not apply to ..."
>
> All a bit irrelevant anyway as Ath5K code (not the .h file) say:
>
>  * Alternatively, this software may be distributed under the terms of the
>  * GNU General Public License ("GPL") version 2 as published by the Free
>  * Software Foundation.
>
> So Jiri is choosing to distribute it under the GPL, and with his changes
> GPL only.
>
> So whats the problem ?

BSD code can definitely be brought into a GPL project as you describe.
The problem is the other direction.

Aren't patches made against the kernel GPL'd if the author doesn't
explicitly grant them more liberal BSD license in addition?

The problem then comes in taking the patches that were only made
available against GPL code and reshipping them under the BSD license
without the author explicitly agreeing to this.

What if a patch spans both code that is pure GPL and code imported
from BSD, how do you license it?

-- 
Jon Smirl
jonsmirl@gmail.com
