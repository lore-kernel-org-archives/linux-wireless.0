Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35186 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbXL1N3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2007 08:29:31 -0500
Subject: Re: [PATCH 0/8 v3] mac80211/iwlwifi: integrate IEEE802.11n A-MPDU
	Rx MLME
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11985948383801-git-send-email-ron.rindjunsky@intel.com>
References: <11985948383801-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-01zlZNIbAsU22+EKGEpg"
Date: Fri, 28 Dec 2007 14:29:19 +0100
Message-Id: <1198848559.4103.112.camel@johannes.berg> (sfid-20071228_132933_624799_C5A486CC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-01zlZNIbAsU22+EKGEpg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-12-25 at 17:00 +0200, Ron Rindjunsky wrote:
> This series of patches contains implementation for the IEEE802.11n=20
> aggregated MPDUs (A-MPDU) MLME. The series handles Rx A-MPDU (recipient p=
arty).

Looks fine to me. John, we could probably merge 1-7 as a single patch, I
don't see much point in splitting it up in the final tree. It was good
for reviewing but I don't see why we want that in the tree later. Don't
care much though.

johannes

--=-01zlZNIbAsU22+EKGEpg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3T6LqVg1VMiehFYAQKiFQ//VCCikF5wUdFHJaH1VV6X3iiKFUitku8E
Pi1wB2ZyEeNJM5Tb1Cz3tmlCntyyHmcivwc5PAqQ6dii4wtMQtWFVoJOqknmnHV/
SqbXCz1Nb7sMW/w/nSP4QyEVjURjy/j1rC/7e8GKw6Hu20OWkAsVMekHU+jvns6G
VerFkjhQPwWtAS1Lbnf12XTjooIfD9TgLNv/UMg7AynsFPKtuzLeJXwYFVXll+We
vF5HX1pd4EH140wXHYK3K/QVM4/BtdToEEupZ+maVA0wILxeW2rsRXE0mnLQXiDu
2CRgcxdJmQV/mPuQrVUPzy0wI5p0nYPbzX4/a79kU/yc/LjLl2HLse9TSubDQWg3
2vBYf2esfzgiyOQ+WZdiCt+ooNAIej/+BXvycGjcnyEcfV8KKfGQwEH83Yz7cy6p
5oG2QsraniL1abISRppx4v569DtgkQmPJs0hkrUN4ZdYyrJdhmiT6sMe0n2+boj5
guytuvmJN8O0oUmxpSXPbYTMbZG3xHPrEUwkdvr3BK0KgCQqdApYyVyTktcNOD+a
wXolPnZgIs6kb77ugaeadcBziGO/3DI1i/FcQBwP4b2WLRujSoRiiUlrkOLdXgfN
mdypCH5yF0gIW3ItuMSV1rIxmqQ5NQufZjYGdXJNWl1C3+OQgOYRUUyEjVOhZWXj
MnKAJ3wO5MI=
=t5La
-----END PGP SIGNATURE-----

--=-01zlZNIbAsU22+EKGEpg--

