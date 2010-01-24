Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0AXLmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 06:42:31 -0500
Subject: Re: Starting hostapd causes kernel panic
From: Johannes Berg <johannes@sipsolutions.net>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, Pavel Roskin <proski@gnu.org>,
	Markus Baier <markus_baier@web.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4B5C0173.9080100@redfish-solutions.com>
References: <loom.20100122T205326-794@post.gmane.org>
	 <1264193623.2593.17.camel@johannes.local> <1264196526.3040.3.camel@mj>
	 <3ef14e53bb12298507dbaec4bb0b98d3.squirrel@secure.sipsolutions.net>
	 <1264197963.9056.0.camel@mj> <1264251576.2593.30.camel@johannes.local>
	 <4B5B6FCA.2070900@redfish-solutions.com> <87aaw4oxh0.fsf@purkki.valot.fi>
	 <4B5C0173.9080100@redfish-solutions.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dQvTioERUUn7ttNft0Lu"
Date: Sun, 24 Jan 2010 12:42:21 +0100
Message-ID: <1264333341.23766.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dQvTioERUUn7ttNft0Lu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-01-24 at 00:14 -0800, Philip A. Prindeville wrote:
> On 01/23/2010 09:58 PM, Kalle Valo wrote:
> > "Philip A. Prindeville" <philipp_subx@redfish-solutions.com> writes:
> >=20
> >>>> Whatever you prefer.  Either way, the panic is fixed now!
> >>>>    =20
> >>> Great, and sorry about that! I'll send a patch to insert the else too=
.
> >>>
> >>> johannes
> >>>  =20
> >>
> >> Did you send that patch? I'd like to apply it. Please copy me when
> >> you send it out.
> >=20
> > Johannes was busy and I sent the patch instead. It's here:
> >=20
> > http://marc.info/?l=3Dlinux-wireless&m=3D126427124317427&w=3D2
> >=20
>=20
> I just applied it to compat-wireless-2010-01-20 and ran it on an AR5413 b=
ut it still panics:
>=20
>=20
> BUG: unable to handle kernel NULL pointer dereference at 0000019f
> IP: [<e0993e7f>] :mac80211:invoke_tx_handlers+0x5be/0xe6a
> *pde =3D 00000000
> Oops: 0000 [#1] PREEMPT

> Pid: 1652, comm: hostapd Tainted: P          (2.6.27.42-astlinux #1)
> EIP: 0060:[<e0993e7f>] EFLAGS: 00010246 CPU: 0
> EIP is at invoke_tx_handlers+0x5be/0xe6a [mac80211]

Are you sure you reloaded the modules etc. correctly? Kinda looks like
the same issue. Otherwise can you send me in private your mac80211.ko
and hostapd config file?

johannes

--=-dQvTioERUUn7ttNft0Lu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLXDIZAAoJEODzc/N7+QmaerEP/RzF5jxUqU6PUOUFzKP2UDW8
+iHwjQnfN3Sr+6FI0aaZfbPN2aQ2eHZgOI/BaGcGH9gYTifmLTAvW0HKXbKZCM7W
Hzm4HXWxhuurDyJ4wEpeGXa04TtmspmSYFMnA7g723Sme1oFayJYIny41IKNk8+w
II9LVOc40365Jdm2Ca4uSIkm/bMrHLgxpkOovysZz1SCEmdURmDJMO98VdNwKAap
O9zH3JCVeIdmKCC+AvCC9agT0AlB7dwP24nAyUqzirviFnufUHOtCtKj8/XwP88s
3SmQY+dvJDWWsxxDKw1aiISwEQrYdKwnEmDPDhzebtLumgTEMw6qBr0XziperTwx
kOxev3PsWuFRf9zkwDC6s9MNRmqih/GoaQtFGbIqfCVNKsp73cqQM3S0RW2YNBZw
p5CcbEkKrAXbTtzcnhxZmQOz4/3RPI4pcQDgH0LzZDeiOvSEuPnvVDxZa15LdKX2
/WxA5A1T5uQ6SuI0KvEmSN8lD+R20DjiGo77R76wwLlT7NapKAjUMB0LvrbpIHiz
s2MbsYMoxV3fIZVRJ2fNyBbUfdLITzVDtKi4IL6Gh4qGW1AgU92NSjrQkemex2or
B6vYNuyxb0jzG6Ab/cLeyCdVchggcohYAnbOPjZET4zsOxP4DMLT/ZW5aJ0a/h1A
V0tpp6IeuxQRFge20FEs
=xqxb
-----END PGP SIGNATURE-----

--=-dQvTioERUUn7ttNft0Lu--

