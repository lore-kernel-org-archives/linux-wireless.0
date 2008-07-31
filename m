Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbYGaSXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 14:23:24 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1ba2fa240807311114t3e1b4fb3oe6643fbe28f2c2ac@mail.gmail.com> (sfid-20080731_201501_253355_AC4EB569)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217411631.10489.103.camel@johannes.berg>
	 <8469FC7DDCBE054D9653D8506E1FF0F001F1E7B606@mucse406.eu.infineon.com>
	 <1217423948.10489.121.camel@johannes.berg>
	 <1ba2fa240807300645j654a82b4rb813b71681dfab71@mail.gmail.com>
	 <1217425854.10489.125.camel@johannes.berg>
	 <1ba2fa240807300659p4d743f31se265f550a2da0dd1@mail.gmail.com>
	 <1217431179.10489.134.camel@johannes.berg>
	 <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com>
	 <1217509511.10489.140.camel@johannes.berg>
	 <1ba2fa240807311114t3e1b4fb3oe6643fbe28f2c2ac@mail.gmail.com>
	 (sfid-20080731_201501_253355_AC4EB569)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aqKPmXkVvgTtyBkfQh1o"
Date: Thu, 31 Jul 2008 20:23:17 +0200
Message-Id: <1217528597.10489.150.camel@johannes.berg> (sfid-20080731_202327_361703_968C1EA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aqKPmXkVvgTtyBkfQh1o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-31 at 21:14 +0300, Tomas Winkler wrote:
> On Thu, Jul 31, 2008 at 4:05 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2008-07-30 at 19:08 +0300, Tomas Winkler wrote:
> >
> >> > Can you explain how starvation happens? In what scenarios? With or
> >> > without aggregation?
> >>
> >> for (queue =3D 0; queue < QD_NUM(hw); queue++)
> >>
> >> This always starts 0  prioritize dequeue the first frame. But what we
> >> need is RR and let HW to prioritize the transmission according AC
> >
> > That's from the old code not having real MQ though, right? I'm totally
> > not concerned about that.
>=20
> Correct. The bottom line is that correct behavior MQ would be shift
> scheduling decision to the HW.

Right. Which brings us back to the original point, why does the hw need
to make the scheduling decision between agg and non-agg?

johannes

--=-aqKPmXkVvgTtyBkfQh1o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIkgMSAAoJEKVg1VMiehFY6mYP/2Na8bPxdm+rVpNjqdPA3Qk7
QL6So2nuZJIDBF3Wx71R0ucUKBmRdX2cr3dYzzKpt6cUxChIIg65FXGZSRUxVodw
YXoQP1w0gLIGQb8+9oCKWpj8FZmnsMRlqDGOAbIUo0FqTs6rrVOPanS7bQvT9nbA
sT5x4jhjnEWLGWoRgUo+trs8rHtPKKs7ayQI7uhWQEV/t3aFmvB1pODtX1Y3XhZx
rjeNg6teu2YWgoYGEWGPEhU5pUapIq2xgpHe6b78FgS0fb8io8D0W/s4gaZdg0Zy
TUiCfuesDJzzt1Hht0012fpks1l8MkmHEk9Zt2oE97DFeHYoAQfR/kLtckAAjg3g
68hmDO9nN3UIWtSRryhth27CkFZbVg5uDfI9JVozTSJv/m3yowJ8PHGME/ktBWqk
7Mipm2flo8by1+T9mPNuxj8M6T4+4uEBX0dur7b1tyDbpXwNjN7Qa89Qq41pkaQj
NYICL+FVz9Ex4EMOtVBOQdwPKskZb8iuq3fgxtpXlrqvftnJCXGP76LnUgoU9B+b
55FWVuieq4iCcagBe/HIf+wD4D6JIIArYmlpeRekZUKTLcpnnsEFfNgNxf59ei0d
dhbMoEowe2hrQAYAK1XYSs0n7op1pCLqX0IBhWLPnCKXujtJzc+Z0AU9fTQArxiI
0P4lxS2JlAmDRadz587y
=VpRF
-----END PGP SIGNATURE-----

--=-aqKPmXkVvgTtyBkfQh1o--

