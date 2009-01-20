Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47738 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762985AbZATVMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 16:12:51 -0500
Date: Tue, 20 Jan 2009 16:12:46 -0500
From: Kyle McMartin <kyle@infradead.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Paul Hickey <paul@christianpatriot.us>, stable@kernel.org,
	Kyle McMartin <kyle@mcmartin.ca>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Failed Build of modules for 2.6.27.9-159
Message-ID: <20090120211246.GD17452@bombadil.infradead.org> (sfid-20090120_221257_250968_3A9218D7)
References: <1232319854.4596.1.camel@localhost.localdomain> <20090119191138.GA4018@tesla> <1232404986.3641.2.camel@localhost.localdomain> <20090120000336.GB4018@tesla> <1232433738.3696.3.camel@localhost.localdomain> <20090120194243.GC19581@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20090120194243.GC19581@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 11:42:43AM -0800, Luis R. Rodriguez wrote:
> On Mon, Jan 19, 2009 at 10:42:18PM -0800, Paul Hickey wrote:
> > Hi Luis,
> >=20
> > 2.6.27.9-159.fc10.x86_64 is the kernel. I burned the distro right f=
rom
> > Fedora.
>=20
> I am =FCber-surprised to hear that FC10 2.6.27 kernels have added
> pci_ioremap_bar() in their kernel header include/linux/pci.h. I
> have verified this by checking:
>=20
> http://download.fedora.redhat.com/pub/fedora/linux/updates/10/x86_64/=
kernel-devel-2.6.27.9-159.fc10.x86_64.rpm
>=20
> I have checked upstrea 2.6.27.9 and even 2.6.27.12 and they do not ha=
ve this. This breaks
> compatibility projects like compat-wireless :(
>=20
> Kyle?
>=20

=4610 will be going to 2.6.28 within a few days... but honestly, if peo=
ple
are going to using out of tree wireless (which is what they're doing,
even if it's going upstream, it's not there now) why can't they just
build their own kernel too?

cheers, Kyle
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
