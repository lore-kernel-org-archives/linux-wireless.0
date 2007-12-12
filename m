Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35210 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXLLRos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 12:44:48 -0500
Subject: Re: [PATCH] mac80211: Fix swapped parameters to
	ieee80211_set_channel()
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: flamingice@sourmilk.net, linux-wireless@vger.kernel.org
In-Reply-To: <20071212153158.GB16947@lunn.ch> (sfid-20071212_160807_495838_2B0FE495)
References: <20071212153158.GB16947@lunn.ch>
	 (sfid-20071212_160807_495838_2B0FE495)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-t9pbAzmlgZeuBWSQXz2l"
Date: Wed, 12 Dec 2007 18:43:46 +0100
Message-Id: <1197481426.6558.138.camel@johannes.berg> (sfid-20071212_174520_933953_65CFA8AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-t9pbAzmlgZeuBWSQXz2l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>                 } else
> -                       return ieee80211_set_channel(local, freq->m, -1);
> +                        return ieee80211_set_channel(local, -1, freq->m)=
;

Good catch, but please resubmit with tabs as indentation and CC John as
he gets to apply patches. Or I can send it on if you wish.

johannes

--=-t9pbAzmlgZeuBWSQXz2l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2Ad0aVg1VMiehFYAQJqFhAAnQEqlacBZQ4gnOWJFW34++bcce6szXwq
s8XQszclMT8lWsFSl+MR6jhqHTMyB52L22qsHDhFYvLwikCXKCIo8vfGUTrl8ddM
gEr+troPoSj83is4aeiEt2xYsuj+eZAFpwn6LTbGSGGmv2UaaI9NiAWBN6KrXwLN
F/dZOMJ/jHMKn6P3O08ezU/yIby+lFYKcrmIG07TnoJGVnuqHkGmFBfmzswjoBmR
C/TwTKV7JWW3hO6ZM6kJuob/x2J8TwemsxFCnBPPyh2F1jD8UHeGdumnkUSlgWvL
WnZZ8ym4oJ1hV/98a0UF8wJjME3/TBL86pQUhYVEOjoDae7yuAaiaesGRFtVWHXq
+sQ3W/dmKNOnJvbUDTeB7Y0fzscM87vPngFjW6W98o0PH95iiwfgpfsuG3HTCvz/
NihIZjXtbJu9IVud2ShcrO8BJveyYn/5w6wCDQIRN02ANfmQDHNu87DtpaURgF8R
2yKllriDtuaUhViDZfaM8sbRb+lpuK6lxVlb0ndlyKtwm2DdMONLdbAKtqKMW64E
vS2Yu1hih5twmfRLr4tIhEPzWeykycFokLTfErgsR2V/IFPv48NoGPTZoe4haD1M
s3lGT63FrCXhTipq/0anwsWj229uOFC5KahFyMArGO0tBiF/1FAUCx+Ni8Qsz6Qb
j2p44+Ch5Oo=
=oCmS
-----END PGP SIGNATURE-----

--=-t9pbAzmlgZeuBWSQXz2l--

