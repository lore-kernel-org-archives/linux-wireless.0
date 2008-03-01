Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbYCAKGc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 05:06:32 -0500
Subject: Re: [PATCH 01/13 v2] o11s: (nl80211/cfg80211) support for mesh
	interfaces and mesh paths
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1204335110.7735.30.camel@localhost> (sfid-20080301_013020_804923_984AFACD)
References: <47be7703.20f8720a.1044.6474@mx.google.com>
	 (sfid-20080222_071730_424685_4330467A)  <1203695866.7082.49.camel@johannes.berg>
	 (sfid-20080222_155831_933711_8528D283)  <1203955392.13162.111.camel@johannes.berg>
	 <1204335110.7735.30.camel@localhost> (sfid-20080301_013020_804923_984AFACD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-H8hjPbwpLePSbKlTuB14"
Date: Sat, 01 Mar 2008 11:06:21 +0100
Message-Id: <1204365981.3938.68.camel@johannes.berg> (sfid-20080301_100654_412930_B30F58FB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H8hjPbwpLePSbKlTuB14
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-02-29 at 17:31 -0800, Luis Carlos Cobo wrote:
> On Mon, 2008-02-25 at 17:03 +0100, Johannes Berg wrote:
> > Can you do that in both nl80211 and mac80211 for both STAs and paths?
> > Look at net/netlink/genetlink.c ctrl_dumpfamily() for an example.
>=20
> I'm not sure I completely get what changes are necessary.
>=20
> What I understand is that I should acquire (if idx =3D=3D 0) and release
> (just before returning -ENOENT) the rtnl_lock() from within (mac80211 or
> equivalent) dump_station function instead of from nl80211_dump_station.
> Is this the whole idea?

Actually. This is a bit weird, I think I'm misunderstanding how it is
supposed to work. I'll dig a bit and let you know.

johannes

--=-H8hjPbwpLePSbKlTuB14
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8kqnKVg1VMiehFYAQISXg/+PnssXnMdKIMdqJHqduR9GftyNqRmXW4r
vyOtCnrM6yPbMg3PS4La6R5+aPFB9+YpX0kn4hEH63kfGbMEdOMKGdpXrXw4HDVD
RSeQPhgrxnkHNqL/NW3a9rzc4kNDtvLRXfyBS/gPfxeurK5sEaf0wiEtgbmda/t4
OkQ+WKOHg62+5RD4jryzRJUPGYbTp0g3WD/pgaQcI0b4iLjvWq/imwVXFCSa+4uE
2nJjo8KGhwkccUlLupBLPblk9MST8bUHMqtRp+EpFJ5YkDzEkUMJxWYXmoULPP/W
k5sp99tronwi0WTvuYoR17mUVZ/A1264+WNPHBX3BTFGyIvEsh4Ga8HuYoqufdpm
c2VLC81ihKv73Dh1zhiGU2h9LbAcAIR4cbF3vwaLQ4q6xYRruxNMD4Bt8Py4RD9B
kZPY/7YjDzvH6aL28Kb1RSIaejQtNIRjo5SZNvSnpWEGHvHzvWwEEHpz+lfiLb1z
oX1EJaskNSnnmsmDW/vBRYi/nt3/jPJWMk0mvvNVxxqK8X3d5rdAKHzlVTTxBPO6
LWT2Sw0OxshbUIlWV7KlxSRF1v+/QfseeBktQPoVu6jeWJpSFAtrutkWeSrOSOtg
MoxjZG0xLuZrj02sslNy5uDfw+jJiH1HjW+WsFaHxka5eDfRxMin4O5GLArJ3/7q
YtrmrdXcE5c=
=Ddqk
-----END PGP SIGNATURE-----

--=-H8hjPbwpLePSbKlTuB14--

