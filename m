Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:62536 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbYFSADV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 20:03:21 -0400
Subject: Re: 802.11 pccard, Agere 0x0156,0x0003?
From: Pavel Roskin <proski@gnu.org>
To: Dave <kilroyd@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Greg KH <greg@kroah.com>,
	Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	Bernhard Reiter <bernhard@intevation.de>
In-Reply-To: <4859866A.1090300@gmail.com>
References: <200806181715.20516.bernhard@intevation.de>
	 <69e28c910806180831j3625db4h6b93836146349fb@mail.gmail.com>
	 <4859866A.1090300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 18 Jun 2008 20:03:19 -0400
Message-Id: <1213833799.5258.13.camel@dv> (sfid-20080619_020325_696788_AD28045E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-18 at 23:04 +0100, Dave wrote:
>=20
> Stefanik G=E1bor wrote:
> > On Wed, Jun 18, 2008 at 5:15 PM, Bernhard Reiter <bernhard@intevati=
on.de> wrote:
> >> Sitting here a  pc card wireless land adapter.
> >> id 0x0156, 0x0003, which probably makes it an Agere card.
> >> cardctl info says:
> >> "Wireless PC Card Model 0110"
>=20
> > This appears to be a Wavelan 2 / Orinoco card. Maybe try adding you=
r
> > device IDs to the Orinoco driver.
>=20
> According to <http://dotpups.de/dotpups/Wifi/drivers-for-Puppy-1/luce=
nt-agere_README>, this is a Hermes II based card, which is not supporte=
d by the orinoco driver.
>=20
> There is a more recent version of the Agere driver available, which h=
as been patched for 2.6 kernels. See <http://ubuntuforums.org/showthrea=
d.php?t=3D304217>

It's really a low hanging fruit.  The big thing that was missing was
firmware download for Agere, but Dave implemented that.  The remaining
work is mostly integration of the pieces together, adding the ID,
allowing initialization without firmware loaded, loading the right
firmware for the card.

I feel bad that I'm too busy with other things to pay enough attention
to older drivers, but we have linux-wireless list now, so I don't need
to be a bottleneck.  Volunteers are welcome.

--=20
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
