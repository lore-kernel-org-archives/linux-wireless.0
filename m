Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbXHHJcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 05:32:22 -0400
Subject: Re: [PATCH] mac80211: probe for hidden SSIDs in pre-auth scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708080056.16195.flamingice@sourmilk.net>
References: <20070807203315.GG3330@tuxdriver.com>
	 <200708080056.16195.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7YKCT4XYXnggjUsSpHMh"
Date: Wed, 08 Aug 2007 11:34:11 +0200
Message-Id: <1186565651.11717.23.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7YKCT4XYXnggjUsSpHMh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-08 at 00:56 -0700, Michael Wu wrote:
> On Tuesday 07 August 2007 13:33, John W. Linville wrote:
> > The ternary conditionals are a bit ugly.  I guess I could recode it
> > with temp vars initialized before calling ieee80211_sta_start_scan.
> >
> Something more like:
>=20
> if (ifsta->auto_ssid_sel && ifsta->ssid_len)
>   ieee80211_sta_start_scan(dev, NULL, 0);
> else
>   ieee80211_sta_start_scan(dev, ifsta->ssid, ifsta->ssid_len);

Except you got the condition inverted.

johannes

--=-7YKCT4XYXnggjUsSpHMh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGuY4T/ETPhpq3jKURAgPLAJsGNamOYdwWcbZ15I5JhO/NUceJ+ACePzzy
Iv7R/RXaJpndeURWba1ZYMM=
=pmqv
-----END PGP SIGNATURE-----

--=-7YKCT4XYXnggjUsSpHMh--

