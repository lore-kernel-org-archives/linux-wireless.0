Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34908 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbYKXRgk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 12:36:40 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 09:36:40 -0800
Date: Mon, 24 Nov 2008 09:36:37 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Davide Pesavento <davidepesa@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	<rworkman@slackware.com>
Subject: Re: crda packaging
Message-ID: <20081124173637.GA6245@tesla> (sfid-20081124_183644_081914_EE468DC1)
References: <2da21fe50810190857j4dacb612u3a2bba4ab3baa7fd@mail.gmail.com> <43e72e890810191828x44624d4fsa8d56170d2ba4f46@mail.gmail.com> <2da21fe50811161258v58efe236r492d59c8b9228b81@mail.gmail.com> <20081117202749.GB5994@tesla> <43e72e890811171421j3f41234dnf451e25d5e58abdc@mail.gmail.com> <2da21fe50811231040i45c3cda5l16379093b4e85265@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <2da21fe50811231040i45c3cda5l16379093b4e85265@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 23, 2008 at 10:40:58AM -0800, Davide Pesavento wrote:
> On Mon, Nov 17, 2008 at 23:21, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > On Mon, Nov 17, 2008 at 12:27 PM, Luis R. Rodriguez
> > <lrodriguez@atheros.com> wrote:
> >> On Sun, Nov 16, 2008 at 12:58:43PM -0800, Davide Pesavento wrote:
> >>> On Mon, Oct 20, 2008 at 02:28, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> >>> > On Sun, Oct 19, 2008 at 8:57 AM, Davide Pesavento <davidepesa@gmail.com> wrote:
> >>> >>
> >>> >> Do you think the regulatory database should be split from the package
> >>> >> that contains the crda daemon? If so, regulatory.bin should be
> >>> >> versioned as well...
> >>> >
> >>> > Yes, absolutely, the idea is to split db.txt into a separate git tree
> >>> > too actually so that should help with keeping track of changes
> >>> > separately and thinking of them separately.
> >>> >
> >>> > We just need to get this git tree created. What crda will need though
> >>> > is to wget the RSA public key so it can be built with support for new
> >>> > arbitrary updates to the binary db. Give us a few days, we'll get this
> >>> > setup.
> >>> >
> >>> >  Luis
> >>> >
> >>>
> >>> Any updates on this?
> >>
> >> I think we'll have this done by the end of the day.
> >
> > OK this is now done. We have a new git tree which John maintains for
> > the database:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git
> >
> > All you need from that is the regulatory.bin, you don't need to run
> > make or anything, just cp the regulatory.bin to the preferred
> > location. Right now this is built into CRDA and its
> > /usr/lib/crda/regulatory.bin.
> >
> > Then do a git pull on crda and try to build and let us know if you run
> > into any issues for packaging. The documentation on the
> > wireless.kernel.org wiki needs some good updating.
> >
> >  Luis
> >
> 
> Great! Thanks a lot!
> Are there any tarballs around? I couldn't find them on
> http://wireless.kernel.org/download/...

I was working on that and now I'm done, heh. I'll send a new post
announcing these URLs.

  Luis
