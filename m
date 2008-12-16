Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYLPKhB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 05:37:01 -0500
Subject: Re: [PATCH,RFC] initial mwl8k driver for marvell topdog wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081216031325.GD21476@xi.wantstofly.org> (sfid-20081216_041336_592667_E12521BC)
References: <20081216025542.GO18056@xi.wantstofly.org>
	 <20081216031325.GD21476@xi.wantstofly.org>
	 (sfid-20081216_041336_592667_E12521BC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tvrzRaWs9mgYqpIb3rim"
Date: Tue, 16 Dec 2008 11:36:59 +0100
Message-Id: <1229423819.4471.35.camel@johannes.berg> (sfid-20081216_113707_633804_84E23EBE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tvrzRaWs9mgYqpIb3rim
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-16 at 04:13 +0100, Lennert Buytenhek wrote:
> On Tue, Dec 16, 2008 at 03:55:42AM +0100, Lennert Buytenhek wrote:
>=20
> > Attached is an initial version of the mwl8k driver for Marvell 88w8xxx
> > PCI/PCIe wireless parts (against 2.6.27.1).  This version was written
> > and tested against the 88w8687 (802.11b/g), but it shouldn't be hard to
> > extend the support to other parts in the 8xxx series, since the firmwar=
e
> > interface is very similar between parts.
> >=20
> > There's an occasional timeout warning with mwl8k_stop(), and hardware
> > crypto is still a work-in-progress, but other than that it looks pretty
> > stable.
> >=20
> > Feedback appreciated!
>=20
> I suppose the mail got eaten because the attachment trips the list's
> post size limit, so I've uploaded a copy of the patch to:

I got it here, but it may have taken longer than expected. I'll review
it at the end of the week if I can, or after Christmas.

johannes

--=-tvrzRaWs9mgYqpIb3rim
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJR4THAAoJEKVg1VMiehFYKSUQAMCvRD38VPgHBnxWodH7a4cN
4Gjc0j03yAY0HH4AV867u3v0Jg2YoxVonLorhPPShII5jwLyyYycifzgTY2uHmkN
lffPgg6NMU9mpVO1Hq4upQ4oGSnqo/YZmy+uTVIpyBbCrW6HfgdhgFlh3s0YEBeK
1PtXqVm6yTJrAkY8/mjHHLxiuq/IpT0qoXEqPTKTjKteukUDDoXAlexC9Hmlq33w
W5pkiR7K+krCAPau+cOLO2YZXf/mFUcGmFKq3Qd8vLZp6qpZOvtaRd3qLtKFtn2u
Efe7m24QQqaZsTXpWCFzeJ6rYLdhDYQDaATjCy7n6565oOHpcGv+gZS3TAOLu+zj
fbSMvf6e2C/GhTnykcUQf40oJNymgXNdK5lkiRyEoc+YVMjhQzDX5wshA+JTMDeT
jKRDthwLeD9RL5ZqMvvwdAVJbhHP6N5A6+7b3FeM3Ec1zQ05L9YZn9mzFLcfrRa+
Ns6ny1cKjuDU54fCrYeJ9nOnlmJh0WtJj3Gs65hodoUEJzysMq1vp2hwb74enu+q
h7Td01hW6CJeWnY28+tGr2597ndeGssw/V+AdBj7q6Kn/szPFm7duWFr0A1yuEbc
IfhlFrYkQjTOP3n0MFk61nsyycAjl/5r5RvaRjwrKA4vCHjXDqxcIEFh11hv4yr/
Z7lFQTfxgBOMsVrpenzx
=4i1M
-----END PGP SIGNATURE-----

--=-tvrzRaWs9mgYqpIb3rim--

