Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12972 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYKQU15 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 15:27:57 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 12:27:57 -0800
Date: Mon, 17 Nov 2008 12:27:49 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Davide Pesavento <davidepesa@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: crda packaging
Message-ID: <20081117202749.GB5994@tesla> (sfid-20081117_212800_758659_4D6EA736)
References: <2da21fe50810190857j4dacb612u3a2bba4ab3baa7fd@mail.gmail.com> <43e72e890810191828x44624d4fsa8d56170d2ba4f46@mail.gmail.com> <2da21fe50811161258v58efe236r492d59c8b9228b81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <2da21fe50811161258v58efe236r492d59c8b9228b81@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 16, 2008 at 12:58:43PM -0800, Davide Pesavento wrote:
> On Mon, Oct 20, 2008 at 02:28, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > On Sun, Oct 19, 2008 at 8:57 AM, Davide Pesavento <davidepesa@gmail.com> wrote:
> >>
> >> Do you think the regulatory database should be split from the package
> >> that contains the crda daemon? If so, regulatory.bin should be
> >> versioned as well...
> >
> > Yes, absolutely, the idea is to split db.txt into a separate git tree
> > too actually so that should help with keeping track of changes
> > separately and thinking of them separately.
> >
> > We just need to get this git tree created. What crda will need though
> > is to wget the RSA public key so it can be built with support for new
> > arbitrary updates to the binary db. Give us a few days, we'll get this
> > setup.
> >
> >  Luis
> >
> 
> Any updates on this?

I think we'll have this done by the end of the day.

  Luis
