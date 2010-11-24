Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57300 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab0KXS7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 13:59:45 -0500
Date: Wed, 24 Nov 2010 13:50:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [ANN] wireless-regdb: master-2010-11-22
Message-ID: <20101124185044.GA16361@tuxdriver.com>
References: <E1PKkCh-0005Ay-R2@sipsolutions.net>
 <4CED4464.2000106@archlinux.org>
 <20101124170639.GD7435@tuxdriver.com>
 <AANLkTin2n7ofZ0oom_aD+V4aFZ3dti1P77Mh6bpZOE6Z@mail.gmail.com>
 <20101124175035.GG7435@tuxdriver.com>
 <AANLkTi=BBw=T98eq2SXuvaLsQ=g8M9H4uLaCxOT0Ju44@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTi=BBw=T98eq2SXuvaLsQ=g8M9H4uLaCxOT0Ju44@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 24, 2010 at 10:04:50AM -0800, Luis R. Rodriguez wrote:
> On Wed, Nov 24, 2010 at 9:50 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Wed, Nov 24, 2010 at 09:33:36AM -0800, Luis R. Rodriguez wrote:
> >> On Wed, Nov 24, 2010 at 9:06 AM, John W. Linville
> >> <linville@tuxdriver.com> wrote:
> >> > On Wed, Nov 24, 2010 at 05:59:16PM +0100, Thomas Bächler wrote:
> >> >> Am 23.11.2010 05:10, schrieb
> >> >> wireless-cdvu00un1VgdHxzADdlk8Q@public.gmane.org:
> >> >> > A new release of wireless-regdb (master-2010-11-22) is available at:
> >> >> >
> >> >> > http://wireless.kernel.org/download/wireless-regdb/wireless-regdb-2010.11.22.tar.bz2
> >> >> >
> >> >> > SHA1 sum: d0b008b4d32105cf6a87860b5a69e8066b03baaa
> >> >> >
> >> >> >
> >> >> > For your convenience the individual regulatory.bin file can be downloaded from:
> >> >> >
> >> >> > http://wireless.kernel.org/download/wireless-regdb/regulatory.bins/2010.11.22-regulatory.bin
> >> >> >
> >> >> > SHA1 sum d7e558216ebe4d5ad01ccb0029c64456f740b9fd
> >> >>
> >> >> Hello,
> >> >>
> >> >> the binary does not work for me:
> >> >>
> >> >> $ sha1sum 2010.11.22-regulatory.bin
> >> >> d7e558216ebe4d5ad01ccb0029c64456f740b9fd  2010.11.22-regulatory.bin
> >> >> $ regdbdump ./2010.11.22-regulatory.bin
> >> >> Database signature verification failed.
> >> >>
> >> >> The old 2009.11.25-regulatory.bin works fine.
> >> >
> >> > It seems to be working for me, even on a freshly installed RHEL6 box
> >> > (so no random keys scattered about).
> >> >
> >> > Anyone else seeing this issue?  I seem to remember that we had a
> >> > similar problem some time back...?
> >>
> >> I see the same issue:
> >>
> >> mcgrof@tux ~/devel/crda (git::master)$ ./regdbdump
> >> /home/mcgrof/2010.11.22-regulatory.bin
> >> Database signature verification failed.
> >
> > Alright, looks like I mislocated a key file when I switched laptops.
> > I think it is corrected now...give it a try?
> 
> What's the URL?
> 
> mcgrof@tux ~/devel/crda (git::master)$ ./regdbdump 2010.11.22-regulatory.bin
> Database signature verification failed.
> mcgrof@tux ~/devel/crda (git::master)$ sha1sum 2010.11.22-regulatory.bin
> d7e558216ebe4d5ad01ccb0029c64456f740b9fd  2010.11.22-regulatory.bin

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-regdb.git;a=blob_plain;f=regulatory.bin;hb=a60a1d5b43e249502309c75707e3b220ce0fc48d

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
