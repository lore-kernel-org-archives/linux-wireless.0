Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from build.ossfans.org ([67.223.233.67]:55906 "EHLO
	build.ossfans.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbZFGWgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 18:36:42 -0400
Date: Mon, 8 Jun 2009 02:36:20 +0400
From: Sergey Lapin <slapin@ossfans.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
	David Miller <davem@davemloft.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 2/5] net: add IEEE 802.15.4 socket family implementation
Message-ID: <20090607223620.GA9606@build.ossfans.org>
References: <cover.1244337432.git.slapin@ossfans.org> <47c250c4bb2069d4faa2d6c5217d1aae15a5bc34.1244337432.git.slapin@ossfans.org> <20090607062543.GA10730@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090607062543.GA10730@uranus.ravnborg.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 07, 2009 at 08:25:43AM +0200, Sam Ravnborg wrote:
> > --- /dev/null
> > +++ b/net/ieee802154/Makefile
> > @@ -0,0 +1,4 @@
> > +obj-$(CONFIG_IEEE802154) +=	af_802154.o
> > +af_802154-objs		:= af_ieee802154.o raw.o dgram.o
> > +
> > +EXTRA_CFLAGS += -Wall -DDEBUG
> 
> Please change this to following style:
> > +obj-$(CONFIG_IEEE802154) +=  af_802154.o
> > +af_802154-y               := af_ieee802154.o raw.o dgram.o
> > +
> > +ccflags-y += -Wall -DDEBUG
Ok, I'll re-submit whole request monday night hoping to get some more
review. Thanks!

S.

