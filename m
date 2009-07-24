Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbZGXQJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 12:09:20 -0400
Subject: Re: PCI express card that does AP mode? (abit wlp-01?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1248451440.21715.27.camel@mj>
References: <wfljmpm4xl.fsf@calligramme.charmers>
	 <1247762215.4235.21.camel@mj> <wf1vogmujw.fsf@calligramme.charmers>
	 <1247775641.6841.16.camel@mj>   <wfzlau7co1.fsf@calligramme.charmers>
	 <1248449030.21715.23.camel@mj>  <1248449371.32151.23.camel@johannes.local>
	 <1248450733.21715.26.camel@mj>  <1248451197.32151.26.camel@johannes.local>
	 <1248451440.21715.27.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mBi4jtOlCLaLfVPhm7Z8"
Date: Fri, 24 Jul 2009 18:09:17 +0200
Message-Id: <1248451757.32151.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mBi4jtOlCLaLfVPhm7Z8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-24 at 12:04 -0400, Pavel Roskin wrote:
> On Fri, 2009-07-24 at 17:59 +0200, Johannes Berg wrote:
> > On Fri, 2009-07-24 at 11:52 -0400, Pavel Roskin wrote:
> > > On Fri, 2009-07-24 at 17:29 +0200, Johannes Berg wrote:
> > >=20
> > > > > From the
> > > > > users' perspective, PCI and PCI Express are different busses and =
should
> > > > > be listed separately.
> > > >=20
> > > > I'm not sure. The ID spaces are the same really, and users really d=
on't
> > > > distinguish that much, for them PCI-E is just the new PCI technolog=
y
> > > > with a different form factor. Kinda like mini-pci vs. pci.
> > >=20
> > > We can have "form factors": PCI, CardBus, MiniPCI, PCIe and PCI
> > > ExpressCard.
> >=20
> > I've done that and adjusted a few of the b43 entries, go check it out :=
)
>=20
> Thanks!  I'll update what I know.

I also added a short overview over the form factors on the page:
http://wireless.kernel.org/en/users/Devices/PCI.

FWIW, I've spelt it "Mini-PCI", and it would be good for the filter if
we used a consistent spelling.

johannes

--=-mBi4jtOlCLaLfVPhm7Z8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKadymAAoJEODzc/N7+Qmac5EP/3CqyAndU8hMNS6GcwPvkndd
uLH8XaOiBU8coHg+u1VUaRueEFnlhyNVDNatreUAs05wccQVXKjC0fT5+OuouHeV
TKqdtW7G4cH3Hy8IO3dSoHQJlLnlrCIROK0vQW6kbxyWe1RCOF5IIbcVNptvy1es
YfefmoKrrkoIvUCrwTvvn9ZIosSAbIXv42vgP6++9M/Vge+3JkS5JVw7kmT9hPuW
C1SZmxrFGUFaL8/xntoN4N75UoRojZukrudfr8TU0o+DhEuGj//ABZB+une9gQEk
io5nq6q8vaNR7UZ4+hoAyr8h093zwprL/tXVz+OZf78q5rA7Hew2ljNw9QFmJUsM
zsBAs1BqzsJ8jKhUiNjAxpFUoJoux53LkM9gRuezU3IdGgYao6P+u5mlmeJqM2tU
21m0zMWdH4Sk6kY2vFjXPeevk7XDKH/9gkIeGF4IbQkpytf73L5ueZ4OuUoeTkPD
xlUqZsVeVPfF0RD8kJNSvYbzkaA7Bnjr43+6zOV8MNA7Joybsj/ForebrUY4xeHR
aoVvoaReYP+rTw8+AieZTrXSfH9mKfpiLOopNyJekqg/xfl3MwxVkP+oHZ2e/W49
SyKV++1poouOhlWbGIY5EQmh2C6nu47kJRxCiL33ZLWoOxUDwCyazPhIeXQOCW2a
24lEGMLPjsrKWjySvR7l
=rIOa
-----END PGP SIGNATURE-----

--=-mBi4jtOlCLaLfVPhm7Z8--

