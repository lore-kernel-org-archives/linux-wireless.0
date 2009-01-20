Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53948 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbZATUQY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 15:16:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] Failed Build of modules for 2.6.27.9-159
Date: Tue, 20 Jan 2009 21:15:21 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Paul Hickey <paul@christianpatriot.us>, stable@kernel.org,
	Kyle McMartin <kyle@mcmartin.ca>,
	linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
References: <1232319854.4596.1.camel@localhost.localdomain> <20090120194243.GC19581@tesla> <20090120200515.GA5077@kroah.com>
In-Reply-To: <20090120200515.GA5077@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200901202115.22231.mb@bu3sch.de> (sfid-20090120_211629_072374_E07D70CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 20 January 2009 21:05:15 Greg KH wrote:
> > I am =FCber-surprised to hear that FC10 2.6.27 kernels have added
> > pci_ioremap_bar() in their kernel header include/linux/pci.h. I
> > have verified this by checking:
> >=20
> > http://download.fedora.redhat.com/pub/fedora/linux/updates/10/x86_6=
4/kernel-devel-2.6.27.9-159.fc10.x86_64.rpm
> >=20
> > I have checked upstrea 2.6.27.9 and even 2.6.27.12 and they do not =
have this. This breaks
> > compatibility projects like compat-wireless :(
>=20
> compatibility projects should be checking for the absense or presence=
 of
> specific functions, not triggering off of kernel release numbers :)

Yeah, well. But it's hard to do, if you can't do it in the preprocessor=
=2E
So you can really only check for macros, not functions.

--=20
Greetings, Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
