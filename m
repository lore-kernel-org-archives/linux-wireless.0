Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34605 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754415Ab1DNMx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 08:53:58 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: 622753@bugs.debian.org, Gunnar Stahl <gunnar.stahl@gunnarstahl.org>
In-Reply-To: <20110414123925.31837.14741.reportbug@noomadix>
References: <20110414123925.31837.14741.reportbug@noomadix>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-Dy1lD+8eO7uO7nQ72byi"
Date: Thu, 14 Apr 2011 13:53:55 +0100
Message-ID: <1302785635.5282.690.camel@localhost>
Mime-Version: 1.0
Subject: ath9k: Connection over wlan slows down and dies
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Dy1lD+8eO7uO7nQ72byi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I received this bug report on ath9k:

On Thu, 2011-04-14 at 14:39 +0200, Gunnar Stahl wrote:
> Package: linux-2.6
> Version: 2.6.38-3
> Severity: important
>=20
> Since linux-image-2.6.38-2-amd64 the wlan connections on this machine is =
1)
> slow to connection and 2) slows down to a crawl and 3) dies after some se=
conds
> / mintes and becomes completely unusable.
>=20
> Connecting over standard eth0 makes no problems at all. Only the wlan is
> affected.
>=20
> Booting the same machine again with linux-image-2.6.32-5-amd64 turns the =
wlan
> back to normal again.
[...]
> 02:00.0 Network controller [0280]: Atheros Communications Inc. AR9285 Wir=
eless Network Adapter (PCI-Express) [168c:002b] (rev 01)
> 	Subsystem: AzureWave Device [1a3b:1089]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 17
> 	Region 0: Memory at feaf0000 (64-bit, non-prefetchable) [size=3D64K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ath9k
[...]

Further system details at <http://bugs.debian.org/622753>.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-Dy1lD+8eO7uO7nQ72byi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATabuXee/yOyVhhEJAQpm3xAAmrwmYDAq97kBKULVGWiLj+7Hgx1yUs7E
nijPZ1kuTuIb2+ok6c/CfkzTvGajt+Hz6XESeXEj1JrQ+wHjezHjhn85Uh5W1rsz
9Ksq6hvhIGciWhg511gXMeRYNTp6P+09KqMhF9GDlGsIi7Ha8LEbumjaaa7LM9w0
KZbRQZXLSOCK1FK0vU11mujUxClnHSLqzTQlb5RyqA8Iosv8RRqA09/Jv52Xp8gB
Pu/H6YAL7iLOCOjbpVpuf7sLgsRiGFDn/P/mnoUSBFnwLvjrdEGr+mTJTAVwjq73
B+KlfmGVbfXknpYfsyHN7+NOOH6ukk/8drGLWru01rVozoghCj+80lwpUlusXfKL
wT3BWCiZrEfDiaYN85WRCMBH1MpGuJxZNJgQiLygZtblELijjo75A2sswpKv2AW2
N944WXNJwKiDyqtUR2PQhsZ0u8rLwfwbftyBUNY/hiYg0qVjpU6fmL5I1JTDzA2D
qDsKRWYWANDT1oBTvylkhYODbbUut4YVLzuBrA9LjFKcNB+YLdRZyetDg+Du5yMs
ujgi159NViWe/opfjk0p0VCloNOyLQhHgoHcVJdtqsSR8QnSw9jFLZI5CBMnsOUT
J7pMis84xD49U2kPbe4jnX+sT9RsQcMKT3DQKyoEeHHLnvNxutnyH7nSYrQrGHvg
+TdEtsVXyao=
=7hHY
-----END PGP SIGNATURE-----

--=-Dy1lD+8eO7uO7nQ72byi--
