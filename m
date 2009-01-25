Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f10.google.com ([209.85.219.10]:50357 "EHLO
	mail-ew0-f10.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbZAYKmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 05:42:04 -0500
Received: by ewy3 with SMTP id 3so409508ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2009 02:42:01 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] wireless-regdb: add example spec file
Date: Sun, 25 Jan 2009 11:41:26 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1232752577-24011-1-git-send-email-lrodriguez@atheros.com> <200901241227.48939.helmut.schaa@gmail.com> <20090124203746.GB22475@tesla>
In-Reply-To: <20090124203746.GB22475@tesla>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901251141.27669.helmut.schaa@gmail.com> (sfid-20090125_114221_601069_FCF0A682)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 24. Januar 2009 schrieb Luis R. Rodriguez:
> On Sat, Jan 24, 2009 at 03:27:48AM -0800, Helmut Schaa wrote:
> > Am Samstag, 24. Januar 2009 schrieb Luis R. Rodriguez:
> > > This is a simple example spec file which can be used
> > > by RPM distributions. Note that the man page isn't yet
> > > installed as it has not yet been commited.
> > >
> > > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > > ---
> > 
> > [...]
> > 
> > > +%install
> > > +install -m 755 -d %buildroot/%crda_lib
> > > +install -m 644 regulatory.bin %buildroot/%{crda_lib}/regulatory.bin
> > 
> > Why not make use of "make DESTDIR=%buildroot install" here?
> 
> Since its in the spec file you have direct control over that, what would
> be best is to get wireless-regdb makefile to use DESTDIR and then just
> have the spec file call make install. I sent the patch for the first part
> already, so the spec file can be changed once that goes in.

Yes, I saw your patch that allows DESTDIR usage and was just wondering why
not make use of it.

Thanks,
Helmut
