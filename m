Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41448 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYGDLDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 07:03:46 -0400
Subject: Re: rt61 and TSF reporting?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200807041302.44288.IvDoorn@gmail.com> (sfid-20080704_125645_560925_85131DEE)
References: <1214907990.7763.40.camel@johannes.berg>
	 <200807041302.44288.IvDoorn@gmail.com>
	 (sfid-20080704_125645_560925_85131DEE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-poQs5n91C2GrDGDcNmYA"
Date: Fri, 04 Jul 2008 13:02:42 +0200
Message-Id: <1215169362.19862.2.camel@johannes.berg> (sfid-20080704_130351_545531_7C69BFB1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-poQs5n91C2GrDGDcNmYA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I just received an answer from Ralink about this issue,

Cool.

> 1.       For 11b/g based chips rt2500, rt2570, rt61, rt73 doesn't impleme=
nt this.

Oh, too bad.

> 2.       For 11n based chips, there is one MAC register have to enable to=
 have this feature.
> 	  But, Word 2 of RXWI will put the timestamp and the RSSI will put to Wo=
rd 3.
> 	 The original Word 3 SNR will disappear and replace by RSSI.

Nice.

> As for the timestamps in 2400 and rt2800, they are both in 32bits, so I a=
m not sure how
> reliable they will be for IBSS.

Well 32-bits is plenty if you can also read the TSF to extend it to 64,
b43 only gets 16 by the firmware and we just extend it on packet RX.

johannes

--=-poQs5n91C2GrDGDcNmYA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIbgNNAAoJEKVg1VMiehFYeaYP/iC2SGwxKvjRhdfl9UMY5Dtu
0v1bh0jVRexz0KVwbHTNvKgcdUlGmCZj9q2YpQcuuNrn4b2qkQILcI+q9a3dMaTW
yKMZyay/8dKehNBZ81VNWbgxrhm+FWH1c5FUHqs77oti9Q4osOD7EQhK2ijWUeyR
7Vg3FipJ0HuCtYCmoh78Y6eAmnHMR676SPGOPl8lFCZErpiHKxgy2dGurEMzEblo
qv2plnSJ2xaoCwhtdsj8Azhv9/BBVl5ok+Ihs+vlbx/hsBp61m3EsKGDUKfGKG/E
MrnmJiWciR80F3XgpoOxL2BGlA1N6ldCIuv/UvlhKOnvYvnoYbZKMGs/vgqUcYa0
sRpep5CfFXSHtKmtBUHjJ4J4APk/NaRSaljOtz9nhJXUThaf81j/Ui+RNCcKNttT
K8vFNN5PBxY5WNuy7y73WgXd8dKLlb6fwE6IbZjJDw0RQAjK/4c7p6t2wD2M9kbv
/v1SBZWhg3sSVSLZAqqEX8mXxy82DTi0erfzRJ9ignRaI/0AaOwncVE4KH04RhEp
U0JH9bbKLtJd8ezntwHrs+RrBQB6Y4fVcy471euFezUtb7iLBDzmMZVhQeXSkI5O
s63TGNL997n4dlcwp4OamEiGKiK1hd2RXIKG5kGTu+X6KlKDuF70qYCuO2O7q2R2
hCDAhjqtc5ZO1lCSKfok
=bJgr
-----END PGP SIGNATURE-----

--=-poQs5n91C2GrDGDcNmYA--

