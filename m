Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259AbYDVR1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 13:27:24 -0400
Subject: Re: 11h IE conflicts with 11s
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Javier Cardona <javier@cozybit.com>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <1ba2fa240804221003o25515740r71c3210d3c9ffb91@mail.gmail.com> (sfid-20080422_190449_448776_EBE38E9D)
References: <1ba2fa240804221003o25515740r71c3210d3c9ffb91@mail.gmail.com>
	 (sfid-20080422_190449_448776_EBE38E9D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BkgjBJMvrCrSduBO22zY"
Date: Tue, 22 Apr 2008 19:26:47 +0200
Message-Id: <1208885207.31429.43.camel@johannes.berg> (sfid-20080422_192810_768096_F5B78E3E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BkgjBJMvrCrSduBO22zY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


> I found this conflict in information elements in curse of 11h implementat=
ion
>=20
> enum ieee80211_eid {
> WLAN_EID_MESH_CONFIG =3D 36,      /* Pending IEEE 802.11 ANA approval */
> WLAN_EID_MESH_ID =3D 37,          /* Pending IEEE 802.11 ANA approval */
>=20
> WLAN_EID_SUPPORTED_CHANNELS =3D 36,
> WLAN_EID_CHANNEL_SWITCH =3D 37,
> }
>=20
> I finding it very unlikely that this IDs will be assigned to MESH IEs
> as 11h is already approved.

Heh. Interesting. I just looked at the ANA spreadsheet
(=EF=BB=BF11-08-0227-00-0000-ana-database-assigned-numbers.xls) and there T=
Gs
doesn't even have any tentative assignments although all other TGs do.
But TGh is still listed there rather than being subsumed into
802.11-2007, what's up with that? Is there a new TGh?

johannes

--=-BkgjBJMvrCrSduBO22zY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASA4f1aVg1VMiehFYAQKxARAAwKodAh89Y7H+StZII7w4nZu5IiZTzUny
3/SxQqFfYtnTKuU41m/wpYJw8Y3KyiX/7+b3nAlOBhJDJVwxIR1hDzUOpDGuZh1E
AWSYDoNNM/lCzDf9yOdieas1WlwvCuok42iFj3DC7utX+RKb+ebbogQ4iD+dz6VH
HVBWxfzZFyiEuduNexc+H5b7U5KBvwDutxRG325ymgiO+2adJkgah1RVJ4lwNfeB
mcZHFzirSNv2u/PM2vHKL1JFlJGY7a9T6cnzSeBDYnMLvTjKC7PuPRB1CeNn19N5
QWmO7LgfmSEDIKnF6zOnb1vmCqCJ3Wi2jaPljqiIaJTM3k8R4TEOQq/hiCS3f2GM
sr2gd0yZ+gPevGl16EeWiV8IQkxr641+2tSX5uzuRlNf9v6Czla5+O+41Asr1GAi
DN0TUIAUGPxfWNqYjvkLj/Lcvfhwmd03NUZ7l8lXLITt4nHVI5paS59aClBk0f7d
puTWawL4dVDb5AmxePujxSwz53/Y6jm37jOmLVIjlv5lvWb95eqWW7orPlBR7WrE
ssdhL7JzL4+On+25SvNwOBixgGVC7QcXpvs1L+w9FgcWXHNhRrW3NvhsAGwkQVDz
UJNjfT2d8uiCH0YKNMjD+GKiWsYlQjnzkjYLTdAIjYBRe61cyroBFA+d0S3Jvfqb
2cG5E+hZREA=
=EEf8
-----END PGP SIGNATURE-----

--=-BkgjBJMvrCrSduBO22zY--

