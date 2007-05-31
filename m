Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58482 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281AbXFAJsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 05:48:06 -0400
Subject: Re: [PATCH] softmac: use list_for_each_entry
From: Johannes Berg <johannes@sipsolutions.net>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Jezak <josejx@gentoo.org>, Daniel Drake <dsd@gentoo.org>
In-Reply-To: <20070527142740.GB13105@APFDCB5C>
References: <20070527142740.GB13105@APFDCB5C>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YO+zLSefWkTbtA1wxw97"
Date: Thu, 31 May 2007 22:24:24 +0200
Message-Id: <1180643064.18266.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YO+zLSefWkTbtA1wxw97
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-05-27 at 23:27 +0900, Akinobu Mita wrote:
> Cleanup using list_for_each_entry.

> This patch adds missing NULL check and trims a line longer than 80
> columns.

Both patches look good to me but I do wonder why you're actually looking
at this code :)

I sure hope somebody will port bcm43xx driver to mac80211 (again) soon
so we can remove softmac.

johannes

--=-YO+zLSefWkTbtA1wxw97
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGXy74/ETPhpq3jKURAsTeAJ976OSXng85Z5Nb85FvNxI9K7WtbgCgtJ0d
Xm1gieljEUVxfQ0UbupP5hw=
=91B5
-----END PGP SIGNATURE-----

--=-YO+zLSefWkTbtA1wxw97--

