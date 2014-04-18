Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:36923 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaDRGUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2014 02:20:08 -0400
Message-ID: <5350C3E6.2010504@meshcoding.com> (sfid-20140418_082011_378460_0CDD57A4)
Date: Fri, 18 Apr 2014 08:19:18 +0200
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: The list for a Better Approach To Mobile Ad-hoc
	 Networking <b.a.t.m.a.n@lists.open-mesh.org>
CC: "devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [B.A.T.M.A.N.] [PATCH 2/7] mac80211: add get_expected_throughput
 API
References: <1397484205-20905-1-git-send-email-antonio@meshcoding.com> <1397484205-20905-2-git-send-email-antonio@meshcoding.com> <CAEFj987Hr4iUuHX-_nJN5AcHBLnAeJhhMX9UbqkGffTT+UQFLQ@mail.gmail.com>
In-Reply-To: <CAEFj987Hr4iUuHX-_nJN5AcHBLnAeJhhMX9UbqkGffTT+UQFLQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="V4VlwfQsN8CaicGxEMfmejLdCxHCdWfXD"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--V4VlwfQsN8CaicGxEMfmejLdCxHCdWfXD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 18/04/14 02:56, Yeoh Chun-Yeow wrote:
> Hi, Antonio
>=20
> Do you know whether the calculation of expected throughput in minstrel
> and minstrel_ht are both the same?

not really the same, but they are similar.

>=20
> Any explanation on how the expected throughput is calculated?

Just check patch 5 and 6 :)

Cheers,


--=20
Antonio Quartulli


--V4VlwfQsN8CaicGxEMfmejLdCxHCdWfXD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTUMPrAAoJEEKTMo6mOh1VAqgQAIf+XtXmZEHKU3QcFghPdF2P
oJtDU1P2bZoFnZkOzDRcoA72O4UUsIk6dzPj5LRAyM4PFHyQN7pJtGLWeuLU0E3Z
+TecusWFmhr3CIfDfZ9LDzLg4R/HXoK2S7yYQVm25PgUGo16cGGdgZ+LgFbJUYwJ
xoBe8tqfVmQ3dXKrpDUCLwrv+w9XFHp1oVfAiciTW+4haw/QTkgfuKxUjf+78Sfy
t4nki1GonE3iuC9IRCg9x225XFOuATJ37iPxHPDquvD9XjG+9g8DbHjqjjDKLtTz
pmuYYK0Yo/4GmVcyDpbLlIF7rnsgyGLByLZfTioOXSg3F+QS8m7+plYEgHzU4rjg
/NoAbByiK/Az7CKF0Ko/mFHguCF2OJo/9ScIsX+1p9AEq+fHaA0E6G08WvzoeXqT
zXJa8NOrqfvTMuB4ceH9NpPfVOAlCV99SHar8IeaES0QievkZjAUjPstBFxvzhln
P7RMyn6HE2CawSz/iuzobqByVXaqtrL+mGoQ5d1qOlNlezNmg1VWMkdtEtiRICiQ
Gn5j7H9IqkhU5UReiGTfwndmSVHcRXDM9TZmr/gtS+ziEfMrIh+f2qJo/Ux3PuTA
Ff/GoVnORG/9d4MX4upP/fCSIAMM94TNbWx9NCyri0kC6gCnjtYD0emjfEQ3Z4hk
LJ2WLBjv/v9656zYcWfz
=HIKa
-----END PGP SIGNATURE-----

--V4VlwfQsN8CaicGxEMfmejLdCxHCdWfXD--
