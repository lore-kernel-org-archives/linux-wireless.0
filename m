Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58616 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbXFRIk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2007 04:40:57 -0400
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Michael Wu <flamingice@sourmilk.net>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	David Lamparter <lists@diac24.net>
In-Reply-To: <1182094164.14209.18.camel@xo-28-0B-88.localdomain>
References: <20070611085950.GA5540@mail.intel.com>
	 <200706140935.50779.flamingice@sourmilk.net>
	 <1181996855.9058.39.camel@johannes.berg>
	 <200706161129.13782.flamingice@sourmilk.net>
	 <1182019869.9058.57.camel@johannes.berg>
	 <1182094164.14209.18.camel@xo-28-0B-88.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-J8YIh/ppJDdPB57vn1+T"
Date: Mon, 18 Jun 2007 10:41:36 +0200
Message-Id: <1182156096.5924.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-J8YIh/ppJDdPB57vn1+T
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-06-17 at 11:29 -0400, Dan Williams wrote:

> NM uses wpa_supplicant for 3 basic things:

<snip good explanation, thanks>

> I like pushing most of the config stuff to wpa_supplicant, because that
> basically means that all of that is in _one_ project.  When
> nl80211/cfg80211 land and start getting adopted, that means that only
> _one_ of {NM, wpa_supplicant} needs to get ported over, instead of two.

I can understand that. I guess I'm still dreaming of some sort of ideal
world where NM and wpa_supplicant use nl80211 to communicate so that it
is easier to use a different userspace MLME maybe, or maybe just have
another program like 'iw' work together with the whole lot easily as
well.

johannes

--=-J8YIh/ppJDdPB57vn1+T
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGdkVA/ETPhpq3jKURAg0gAKCMy949L/is/ZS8VAbZbgn6a9AEswCghSmX
lpx1Wv4ezU40iz/2STxOjss=
=Rxib
-----END PGP SIGNATURE-----

--=-J8YIh/ppJDdPB57vn1+T--

