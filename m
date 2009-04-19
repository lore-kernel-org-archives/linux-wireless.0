Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48124 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578AbZDSNWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 09:22:53 -0400
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Alina Friedrichsen <x-alina@gmx.net>
In-Reply-To: <1240094996.21583.1.camel@johannes.local> (sfid-20090419_005015_625875_1781AFCD)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0vSwSgtlL9dqYSO63xfU"
Date: Sun, 19 Apr 2009 15:22:50 +0200
Message-Id: <1240147370.898.0.camel@johannes.local> (sfid-20090419_152257_469848_C5D3A561)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0vSwSgtlL9dqYSO63xfU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 00:49 +0200, Johannes Berg wrote:
> This adds IBSS API along with (preliminary) wext handlers.
> The wext handlers can only do IBSS so you need to call them
> from your own wext handlers if the mode is IBSS.

Hmm, I forgot one thing -- you may want to create an IBSS on a specific
channel, but still allow it scan for other IBSSes. I guess we need a
flag for that and not make "channel set" imply fixed channel.

johannes

--=-0vSwSgtlL9dqYSO63xfU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6yWnAAoJEKVg1VMiehFYe10P/AoVSQCPZfrFEYUueOESYwZM
/YcJpgyI1MUO0I8piQzOCtxNVq4IGd4nTBquQnn46EAOhcoHLuZh9DKfjmkXCcup
vEp2gyW2fg5Qp0pKDb30iVVND5OEX9oSi7n9KYvADStsuvWhPKmBbrovj3lbkmie
19cPw6OYLFlaRXY+pFaKMNjiSfk92Q8yrAOmaGC/xaxaXAAh+Mhd255cuL4XjIFS
s7X+TXrSAkZgelwzddpLF85E/TYRGwi+Jk6+AcF/zBVMoPTKMjhxLkKn6Hvii8Vd
yoMVnah1TowaSurwvsgUsbNnRysIhXQVXiZwos2HLHlJBfIstgGnfaCnqCLGgX5q
PVo6RD0MTQ0pxMxfd4CMV9HULmeVTMPNmfbD2vCqLPlxoQmm3SCXXmVcxpDFzOLp
qhqbeEbT6HRk3sNub86VdmcDWgqTyRSJrKVZ2/FWWwkkM/cK7GjoXl5/C6J9sVYo
OC/Y8ukhN5/sSsj0RUyWCuX53C1U1umGpbzb9Trq0DAd6bkR0Eqp8Z4nLaqXxZ5y
DrxBjKiqNQ9EIZsjny/9DtFjTnQqsu2TdxXiDxpLPPRrvSRi0c+NEq/41nSx0kO8
QfUBw85U6ue7cj973x4SP/kvoBm6hrtMrhWNJApEOAYEIrtM39tWFpnbCiVayzSM
f3XvRGSo4hdk6SuectqH
=Fmwe
-----END PGP SIGNATURE-----

--=-0vSwSgtlL9dqYSO63xfU--

