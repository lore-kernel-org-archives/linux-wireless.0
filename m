Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZCXUbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 16:31:14 -0400
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	Christian Lamparter <chunkeey@web.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
In-Reply-To: <43e72e890903241310m1c09a55ex4c47aebdb483896e@mail.gmail.com> (sfid-20090324_211038_720800_FC11DF19)
References: <200903241938.47155.chunkeey@web.de>
	 <b6c5339f0903241159x505fc88ap4d9850fa74733156@mail.gmail.com>
	 <20090324184100.GA29268@tesla>
	 <b6c5339f0903241303y58aca745rfad05ed8ddb93e70@mail.gmail.com>
	 <43e72e890903241310m1c09a55ex4c47aebdb483896e@mail.gmail.com>
	 (sfid-20090324_211038_720800_FC11DF19)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jR0g7ekthdRDXG9Xpevt"
Date: Tue, 24 Mar 2009 21:31:04 +0100
Message-Id: <1237926664.4320.131.camel@johannes.local> (sfid-20090324_213122_590734_B2A3616A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jR0g7ekthdRDXG9Xpevt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-24 at 13:10 -0700, Luis R. Rodriguez wrote:

> > Channel list is a good hint, maybe
> > it's time to fix iw/nl80211 to send back all the channels :)
>=20
> So that is the other option. I tried looking at that yesterday but
> wasn't able to find a way to do this. I went through the netlink
> documenation and even tried modifying the skb on the kernel side as
> its a dump. Not sure what to do here to fix this.

I looked into yesterday actually, and it's completely non-trivial and
requires userspace interface changes.

johannes

--=-jR0g7ekthdRDXG9Xpevt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyUMFAAoJEKVg1VMiehFYNgIP/iUjx9F95Zk3sVkmLAysUfkG
urJOrSKdC28HK7pErJtvh6n2UMC9z0zXiF+w4bFDdJmgKRNFcaIdVZqCXZRfCZ83
td0X7gtb023tGB+vUEXNLPPtfQflpNDyM2e0AjIirdji813U+zsBmveoz00Z9avH
QN1E60dqjqGz98HzntGzlU4H14EDSyjoPWP26L4ajYQUdVBjs+Eig9EaKsIaQEvV
+vxPuzVXs5v48GKB0IcNFF1VRS9i+Qj0RNqkvcMXNT486AGctspainRN47KdqXSO
Q9/YWYtsAIXOSMsC2C9rCnxFvvcOuTX0rRqNnSSdEtu8ziLXkU2nR839defk0NwF
lhs+v+1V1iXgZLjg3D24Vr3I690logvdjmoqGLzOM+PRjxOVnyOey7Oo6zE4uhBR
Pl0hEjmJoRSeJ+bkPGXCeSd/AbstEs09J2YBUqqHBojLZp4NCMzvdDYZBJ2P+u/y
Vtzhv65KCPc5hrB9FZm5i2O74F+2r6lvzge1XLqiRktyg+RQAP2oiOlFg70F9Kyp
UUxxRlEAoIEXEmKv6McLy4erJTyltHRFyg18q1jlZfPEURI8yNL5kgCM6nlHQaVx
xMlVSPmW9orcoDwilYuFDQbSmsuJjq8VfUSB75/9keqIZ7MztJaGibuLBtbGJZDM
OGardNJFWvuv/k8BTzzW
=q2EJ
-----END PGP SIGNATURE-----

--=-jR0g7ekthdRDXG9Xpevt--

