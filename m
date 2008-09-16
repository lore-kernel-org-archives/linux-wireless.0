Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52796 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbYIPGxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 02:53:47 -0400
Subject: Re: [PATCH 1/2] iwlwifi: don't delay scan in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1221544864-9494-1-git-send-email-yi.zhu@intel.com> (sfid-20080916_080534_864320_B18780DE)
References: <1221544864-9494-1-git-send-email-yi.zhu@intel.com>
	 (sfid-20080916_080534_864320_B18780DE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Gt/xMmOfvzEXMyal7QMr"
Date: Tue, 16 Sep 2008 08:53:03 +0200
Message-Id: <1221547983.8916.2.camel@johannes.berg> (sfid-20080916_085351_703820_7D18B785)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Gt/xMmOfvzEXMyal7QMr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-16 at 14:01 +0800, Zhu Yi wrote:
> From: Tomas Winkler <tomas.winkler@intel.com>
>=20
> Scan need to be delayed only after association to allow EAPOL
> exchange. We don't need the delay for IBSS mode.

FWIW, I'd love to see that delay thing moved into mac80211.

johannes

--=-Gt/xMmOfvzEXMyal7QMr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIz1fLAAoJEKVg1VMiehFYeEMP/1BvBCX/JBHyz8TLfeY/EuZ4
srs2r30o2geP7QtkvPgUJPyZjrDjeuclBA5GfGe3mdkH2bt9UdV4aQAD26O3gF8d
ihPMb7Z748CdNLeDknKoMSpk/+sTWUwzCIKvsElCTb34DDvlSKptsYB8p96F8u5V
FqEqRT8yFMfNrwNtqRavYHiibbDh8lnW8tC05xCFFOSmozNWgxnKtlU23j3FAUQy
GC206HTGILqzbdQW9AY4PEONoCUte88cttpnwE/NsdNvrC37yyG79oNED0rqe5uA
OV7GwDSareyG3yRdItmjVkznvQlMwlV0eZrzC5u6Enizahrwh21jESU5wZteHYGT
ZiZFTGTS9vcg3zEo9oRYY2X5B0QBsPyVtfC11DvKTp5AKct63OjCMgodspeum+b3
WsTh3AQMFezgh3Mc0SQquo7zfIvT4AGTiTmjP6FGIB9n82pJ1CLH06JGZcso+RzC
L14oQBz1Eob5NM89QNJ/mFZKDHUkEGGItiNvNoXiCCe8lMud+uT3vDjb8AcuRl8O
MqcMjZwxQpDb3VwcjJ7/4fdFQUjfAx9bG0oJJNPKHPQh//SaibKcFw5E6hPW7SBu
tzh1ryUkbokGHSbZmHSj1WVsiZSEoQhWOg6FK8RW6bFTZgP6+7nVzY97kwlsuOz8
lhNJOla5a20ZYzkxkssb
=uY01
-----END PGP SIGNATURE-----

--=-Gt/xMmOfvzEXMyal7QMr--

