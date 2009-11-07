Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:36700 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZKGSbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 13:31:35 -0500
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Luis Correia <luis.f.correia@gmail.com>
Subject: Re: [announce] new rt2800 drivers for Ralink wireless & project tree
Date: Sat, 7 Nov 2009 19:31:36 +0100
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jarek Poplawski <jarkao2@gmail.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	David Miller <davem@davemloft.net>
References: <200911031951.05235.bzolnier@gmail.com> <20091107173028.GA1932@ucw.cz> <efe7343f0911071012u73317883wc60f5c188bc853e8@mail.gmail.com>
In-Reply-To: <efe7343f0911071012u73317883wc60f5c188bc853e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911071931.37165.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 07 November 2009, Luis Correia wrote:
> Pavel,
> 
> On Sat, Nov 7, 2009 at 17:30, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> > > So if I want to focus on something different in the kernel, I just send 1 patch,
> >> > > and a second to claim the maintainership of it even though there is an active
> >> > > maintainer available?
> >> >
> >> > What about listing yourself as a maintainer for a start?
> >>
> >> The rt2x00 project is listed as maintainer for everything in the
> >> drivers/net/wireless/rt2x00 folder.
> >
> > Yes, but that tells very little. I don't know who the 'rt2x00 project'
> > is. Perhaps its you? Perhaps its Bart? Maybe its my cat? Please just
> > list real names of maintainers...                 Pavel
> 
> the answer is (and always was available) here:
> 
> http://rt2x00.serialmonkey.com/wiki/index.php/Developers

True, but I agree with Pavel that the MAINTAINERS file should
be instantly clear about who the maintainer is.

I've already send a patch to add update the entry.

Ivo
