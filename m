Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51213 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab3KTQaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 11:30:19 -0500
Date: Wed, 20 Nov 2013 11:25:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ANN] wireless-regdb: master-2013-10-11
Message-ID: <20131120162538.GB2220@tuxdriver.com> (sfid-20131120_173023_708598_E014563A)
References: <20131011202459.GF14329@tuxdriver.com>
 <5272E897.8060606@archlinux.org>
 <20131104191850.GA1989@tuxdriver.com>
 <CAB=NE6XU80NwLA=qW8jOBPZEmiSJ6NoHXDgp1bfs5=5GYnUi3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAB=NE6XU80NwLA=qW8jOBPZEmiSJ6NoHXDgp1bfs5=5GYnUi3A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 20, 2013 at 11:29:50AM +0100, Luis R. Rodriguez wrote:
> On Mon, Nov 4, 2013 at 8:18 PM, John W. Linville <linville@tuxdriver.com> wrote:
> > On Fri, Nov 01, 2013 at 12:32:39AM +0100, Thomas Bächler wrote:
> >> Am 11.10.2013 22:24, schrieb John W. Linville:
> >> > (Cutting the short log, since the original version got classified as
> >> > SPAM on vger.kernel.org...??)
> >> >
> >> > A new release of wireless-regdb (master-2013-10-11) is available at:
> >> >
> >> > http://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2013.10.11.tar.gz
> >> >
> >> > Here is the short log of the changes included since the 2013-02-13
> >> > release:
> >> >
> >> > SNIP -- you'll have to check it yourself:
> >>
> >> We can't use the database file:
> >>
> >> $ regdbdump regulatory.bin
> >> Database signature verification failed.
> >
> > OK, I probably screwed-up something.  I'll investigate, but it may
> > take few days while I recover from some extended travel...
> 
> Hey John, it seems other folks are reporting this as well [0].
> 
> [0] http://forums.gentoo.org/viewtopic-p-7440278.html

Sorry, I dropped the ball after I couldn't replicate the problem
locally.  Does anyone have a suggestion as to what the issue might be?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
