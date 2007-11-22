Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbXKVM5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 07:57:53 -0500
Subject: Re: [PATCH] mac80211: remove "bcn_int" and "capab" scan results
	info
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071122043156.GB8672@jm.kir.nu>
References: <1195664138-21789-1-git-send-email-linville@tuxdriver.com>
	 <1195664475.12000.54.camel@johannes.berg> <20071122043156.GB8672@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2ipz04hvwtkPk7LnWWBk"
Date: Thu, 22 Nov 2007 13:57:37 +0100
Message-Id: <1195736257.6323.89.camel@johannes.berg> (sfid-20071122_125756_937663_F323979F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2ipz04hvwtkPk7LnWWBk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> If I understood correctly, the proposed change was removing 'capab'
> information from scan results(?). If that is the case, that would break
> wpa_supplicant network selection since there would be no information on
> whether the network is using encryption or not (privacy flag) and
> whether it is a BSS or an IBSS. Consequently, I obviously continue to
> object this type of change as long as WE is used for getting scan
> results.

Well, wpa_supplicant currently works, right? And this code is never
triggered before the change to remove scan_flags because scan_flags
cannot be set. Hence, I don't see how wpa_supplicant can possibly need
this information.

johannes

--=-2ipz04hvwtkPk7LnWWBk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0V8v6Vg1VMiehFYAQIHNA//Vn8Epd4h2aipD5vH/XBNomusD1TitJ6b
noegvVgOqiE4NXSaJeK7ZTFh/e9jv7vcnX8YEbCGKono7HcvjTDAJekzsbPUX17a
w6KlRdxI7uFidIt1YQRDgyjVj0reXPln5nXvqqHe+PhITnDclWPgbFXioOCs9TRM
qa+9y7qkFIFdvIAGEJPW/wD717IryBV40K0C2Q1pKSmK7UL81yijzUtrc0F7rDnp
Qpl23E+fHVJyvY1mbLRTtk/5v0yaXzQ+/CWoREc7VlJdV+sLapJOKyCq66FZHPt1
92BGa/kp503vRJNAdWiGP8YSTRUgfpHFJllKX+3ACn9L0a4ik2NlWHUvQND6VgV3
/3v/SNENP5P6afL6xULLnOYuxwKiXdbmYP+S1+NUERR4UwBsQ5FevHMIOt0JnLU5
FKmCYjmR0SBlXlIDHbbmY6XSSjqbqAXEjOVbRsRgIT2Q1XmsclpJv/KfP8jVPi4+
sDZg/TSDdJ+s3toYsTEl4NfEpOkfUqWL0e0lZ5/JNbSBEeBIHslN2az2xvafPL6Z
jwSHkexH9FNxEMxryWLy7CFzdBCq0CRQGgIEb9lUWGHAQNh4xNzJBpGxk3ITatpN
JhPHcmEacyHrdbciVhCvGVMjbWG/fs/FR39qvnmTDQ8ZLlFKj9S3+SC014uLhxaT
wnQu+vLINzI=
=ktEW
-----END PGP SIGNATURE-----

--=-2ipz04hvwtkPk7LnWWBk--

