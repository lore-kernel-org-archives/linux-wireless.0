Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53413 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542Ab0JACwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 22:52:09 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: David Sanchez Herrero <david.krusty@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: 598144@bugs.debian.org
In-Reply-To: <AANLkTi=3saB8VaHfA6pFTnvTdCZVWcMLRAHfO06GvW90@mail.gmail.com>
References: <20100926203325.8583.75263.reportbug@krusty-deb2.mundo-R.com>
	 <1285534242.2697.575.camel@localhost>
	 <AANLkTimMUN45nE9U+ahZQRxH2uqiaCBgRqi2wxR76gr4@mail.gmail.com>
	 <1285636469.28504.51.camel@localhost>
	 <AANLkTikY=z89HFg07zsiox4dvos4Vu1QXpAkCXvdm1JV@mail.gmail.com>
	 <AANLkTi=3saB8VaHfA6pFTnvTdCZVWcMLRAHfO06GvW90@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kJ+JQmh7zhAheoIb17f7"
Date: Fri, 01 Oct 2010 03:52:04 +0100
Message-ID: <1285901524.3916.49.camel@localhost>
Mime-Version: 1.0
Subject: Re: Bug#598144: rt2500pci: very low transfers and link quality
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kJ+JQmh7zhAheoIb17f7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-09-29 at 18:52 +0200, David Sanchez Herrero wrote:
> Hi again,
>=20
> After some troubles that I could solve, I connected the interface, but
> it's impossible to make anything because in all terminals appears one
> message continously:
>=20
> cfg80211: Calling CRDA to update world regulatory domain.
>=20
> I can see that I lose the connection, probably because this message.
> This happens with 2.6.36-rc5-686 kernel. Any idea about solving this
> problem?

No, but the developers on linux-wireless may be able to help.

Ben.

> This problem doesn't exists with 2.6.32-5-686 kernel, but with it, I
> have again the error message that appears in my first report:
>=20
> phy0 -> rt2500pci_set_device_state: Error - Device failed to enter
> state 1 (-16).
>=20
> In this case I don't lose the connection to the AP, but the link
> quality and transfers speed are still low.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-kJ+JQmh7zhAheoIb17f7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATKVM0+e/yOyVhhEJAQJf/hAAjTWd2JqCk1cLocobIRLFCSfmsDZmnl8b
ItQ2d/njN+vbtaWV8vrlMI8p94z6Lxoft1jZT65M8U1iQ1Wd6Fze2pMws67Iszo4
TiB95ssBOEU6Gqhnvvc8CjoTBBsEv+8r0hhoatbbAR0YXTsK5a8McUttEy2uauHz
8Mblj1IvRDsAtks+llFAWKu8P3m+is3BvOH/R6eXm7eid2yhuvZblMxLc/m4brL3
kT21TP/1+KQRFlLRmOitv0L7+div1Q/f+N1swAz0xzYV9nThhqj6wyF8kI+TuXv+
I71OfCslW3vtPKu1cGKBJKewidgAetr361iWwflvfOwzqkj7bBoYf+tuzjYmTc/Q
SzKo1JNKBnO30LqQ+2VCWDU0pOJxNx2Nj0gZRqpquXGInZdw92mRA/gLyHSsFwyC
XMfqZP8pT1mM3oWaVBzvI5olGhnhNo14HcO7E+xQC/PJdLfe3Yh7xvghJzGvMznf
96dhwi9U3p/pF8ULD7iKcxzMwRf0TMmpYYOUuNkLmK5T1/i3F4A0JwFRcMiP8pyv
JFrT5nVFuvJWekfdqBp3Vsn/ma+EUGzKAO1votP24mi9eApKpEA7GE1ttN/2oTfW
+YDoiOxgvUqH/yyCHbEL7pxhOY/4kQLrhzew9NM6B4vkeET0kTugboozRgiQqm2H
uKjPRzJZuak=
=5hzZ
-----END PGP SIGNATURE-----

--=-kJ+JQmh7zhAheoIb17f7--
