Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21134 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028AbZAXUhL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 15:37:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 12:37:11 -0800
Date: Sat, 24 Jan 2009 12:36:33 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Michael Buesch <mb@bu3sch.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless-regdb: adds a manpage for regulatory.bin,
	updates Makefile
Message-ID: <20090124203633.GA22475@tesla> (sfid-20090124_213741_517828_2C038385)
References: <1232751387-22651-1-git-send-email-lrodriguez@atheros.com> <200901240704.24281.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200901240704.24281.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2009 at 10:04:24PM -0800, Michael Buesch wrote:
> On Friday 23 January 2009 23:56:27 Luis R. Rodriguez wrote:
> > This adds a man page for the regulatory.bin file and updates
> > the Makefile to make it the install target flexible for distributions.
> > As part of the install you also now get the the man page.
> >
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >  Makefile         |   19 +++++++++++++++----
> >  regulatory.bin.5 |   37 +++++++++++++++++++++++++++++++++++++
> >  2 files changed, 52 insertions(+), 4 deletions(-)
> >  create mode 100644 regulatory.bin.5
> >
> > diff --git a/Makefile b/Makefile
> > index 07c3030..0171196 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -2,12 +2,16 @@
> >  PREFIX = /usr
> >  CDRA_PATH = $(PREFIX)/lib/crda
> >
> > +SBINDIR ?= /sbin/
> > +MANDIR ?= $(PREFIX)/share/man/
> 
> Why do you define SBINDIR? It doesn't seem to be used.

Sorry, a copy a paste from crda makefile :)

  Luis
