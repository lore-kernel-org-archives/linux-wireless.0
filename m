Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbYLIAwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 19:52:17 -0500
Subject: Re: Userspace tools: Roadmap?
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan E <trg_info@mailhaven.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1228783416.25383.1288982771@webmail.messagingengine.com>
References: <1228692546.8826.1288759933@webmail.messagingengine.com>
	 (sfid-20081208_002919_244971_30E436F9) <1228723993.22164.65.camel@johannes.berg>
	 <1228778295.10662.1288975589@webmail.messagingengine.com>
	 <1228778801.22164.156.camel@johannes.berg>
	 <1228783416.25383.1288982771@webmail.messagingengine.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nfkR1U6tv6K9+dnEiDE8"
Date: Tue, 09 Dec 2008 01:51:43 +0100
Message-Id: <1228783903.22164.166.camel@johannes.berg> (sfid-20081209_015222_761989_1C3CB0A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nfkR1U6tv6K9+dnEiDE8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-08 at 19:43 -0500, Dan E wrote:

> When I reboot, modprobe the driver, and do 'iwconfig wlan0 channel 9
> commit' the .config callback does run.  If I leave off the 'commit' it
> does not. =20

Strange. But .start also runs, right? Something must be turning up the
interface.

> I'm trying to validate as many callbacks as I can before
> moving on to the next step, enabling the interface.
>=20
> An additional question, if I may... Is wlan0 considered a "virtual
> interface" or does that term only apply to additional interfaces created
> with iw?  The whole vif thing has me a little confused.

Yes, wlan0 is a virtual interface too, the first one.

johannes

--=-nfkR1U6tv6K9+dnEiDE8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPcEbAAoJEKVg1VMiehFYRxgP/2oqKncq5D6G6G9itk+l27cr
qU6ehXbjP5QS4z+q5try4sOaeynlJXE7CkLP1jPQq1LclPFVjugVTwN6qX/yvMNd
pZ8wiJa6T6BRPRwTuyVSkT6m4q978zral1UTsW8thH86imbZH/UTJ+PyQXjnh4RQ
+7GHIvuZWCdxhdTdSHsdKxdPE8CVbHlRJTvPH8SRQ+a5AgCHqbmIdIAwL3plHQvz
6r4lGGOr3cU1ilbWK/jK4Rj9LyV1SyI0t5X7C5JDDT/3Kx9o/aJLf+kns2XTLPrn
wOpOJlrT8E9quP80YGHeQq+pUCFm1r1EiEIod/uadjXawqJuiTZJkC0PTiu+eOz2
5TxpMoEQJ9m5ooujTZ/SPXpj6Dn4pv4cjh73wUzvbQSBNipeNy89gcU2WzP7PpRR
9oFqQ6qxcPMRS7KG9mAm6NV7uw7XrDRndOtXHmHZRtChXWPjbBWdmlTQ+woKnmDr
IK3UnKuGkjWhm9ODtKADelCq6Mag1GH7MrbLSiKQvMFnRwbtVTaCqtjguRbs0n9i
zeQtgaA+FrQJfkUvYiPGpvfVfoCBp5o1hUr+rxVM3UZGKt06NwE8AYGD4uj8w3x/
LZNp2Eh9cKBVpo6J7spiyb9G+vFVBHpZSo0qhBe7HOG+SNt48xdjlRWbAjTnhiNR
Ag+q5KD4ukPv9vlISSrU
=pqjF
-----END PGP SIGNATURE-----

--=-nfkR1U6tv6K9+dnEiDE8--

