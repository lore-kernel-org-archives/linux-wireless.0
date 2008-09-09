Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbYIIGdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 02:33:31 -0400
Subject: Re: HT action frame code
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Ron Rindjunsky <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48C5868B.8060103@w1.fi>
References: <1220883730.31304.60.camel@johannes.berg>
	 <48C5868B.8060103@w1.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ze0wkO35GbWbSE6S/Zt1"
Date: Tue, 09 Sep 2008 08:33:24 +0200
Message-Id: <1220942004.31304.101.camel@johannes.berg> (sfid-20080909_083334_051395_13CC1F86)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ze0wkO35GbWbSE6S/Zt1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 23:09 +0300, Jouni Malinen wrote:
> Johannes Berg wrote:
> > When we're an AP, shouldn't we also in some way honour the block-ack
> > action frames? Or will that be done in hostapd, which then sets up
> > block-ack via some unspecified way?
>=20
> The current design assumes that hostapd takes care of all management=20
> frames, so eyes, these would need to go to hostapd for processing and=20
> then setup back to mac80211 through some new command..

Well we can always pick out those action frames in the kernel if we want
to, that's not the problem, is it?

Should the design be changed? It seems that this is more related to the
rate scale algorithm and the "can we support aggregation for this STA"
question, both of which we currently have information about in the
kernel and not hostapd.

johannes

--=-ze0wkO35GbWbSE6S/Zt1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxhiwAAoJEKVg1VMiehFYrnUP/i+Njh4mmucc8Jvo1qYESbt2
/Rq7TTNFGC3W8s9xo3XAYkeJwvBmxk453k9w8xdB6Gklow+23HlilyUepqviBgzL
SFGxFE0edp0D+TUQ4Jn0VrmN2rh0E+3+saCexfy7x90tnNpHYD4jge54N4buAcWr
x5Ml/Diec4ONmG9wLZFXB2RIEzY7k9ldUHQhjvhd9oc2vN80bWfxI/7YUBIi+/hr
WFULt9D7k3kHpkhSiXMOt+yJIw9rcntj4pKUN2z8PdLBmjYapxMo7gSm5iAHAdE6
6HKyL+akSXhtPzmfQhjjbdYV3eaj9Wzy1vlLvq4BdOK3ygATWe71H5INdWvXwRzN
E997SuIxWS8xawWidkKa+mQHIjtAlLsZrDGWTfMvDTP4XzIoa2AfK+6pocosdcO2
IRXdMbpVqTWNvfGBJnBEBKPbGSbFI/Z64yCWmZMGq5N6664AEu2By8odiuSnYaLV
TdLRN3VbgVvjwTkqj4EBXQ1u9ib4lL6enwyGr06cyj48bLo3KX5ZVHkff5iKkGdX
5hCnw7fREBrwYTOfcn15hbJ8N9NacZ/h6vLZOFkN5kfDNEwPxZ39VtU7EPSm1gsy
D0om//tQevpe8KtXcJGZQI+dhx59CRjDCdXfcjbLZYoiiwonTQZA+3NfgErsrEEO
r9Edx57u29gx+QGh/YJG
=yjnJ
-----END PGP SIGNATURE-----

--=-ze0wkO35GbWbSE6S/Zt1--

