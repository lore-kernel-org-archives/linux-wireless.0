Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbYJBSF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 14:05:29 -0400
Subject: Re: [PATCH] [RESEND] mac80211: remove redundant check in
	ieee80211_master_start_xmit (net/mac80211/tx.c)
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <roszenrami@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <b25312890810020648i5e224f3cp1178790fd68d7f3b@mail.gmail.com> (sfid-20081002_154826_252562_28230F2C)
References: <eb3ff54b0810020556s407728b9n772e7ae178761eee@mail.gmail.com>
	 <1222954031.24551.51.camel@johannes.berg>
	 <b25312890810020648i5e224f3cp1178790fd68d7f3b@mail.gmail.com>
	 (sfid-20081002_154826_252562_28230F2C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4U6WergtCmov3LiPXLSN"
Date: Thu, 02 Oct 2008 20:05:24 +0200
Message-Id: <1222970724.24551.57.camel@johannes.berg> (sfid-20081002_200533_286092_6388F29F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4U6WergtCmov3LiPXLSN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-02 at 16:48 +0300, Rami Rosen wrote:
> Hi,
>=20
>  - This patch (against the linux-wireless-next git tree) removes a
> redundant check in ieee80211_master_start_xmit (net/mac80211/tx.c)
> and adjust indentation in this method accordingly.
>=20
>  In this method, there is no need to call again the
> ieee80211_is_data() method; this is checked immediately before, in the
> "if" command (we will not enter this block unless ieee80211_is_data()
> is true, so that the "and" (&&) condition in that "if" command will be
> fullfilled ).

Looks good to me, but I think you should look a bit more into how to
format a proper patch and try to send it inline rather than as an
attachment. Have you seen http://linux.yyz.us/patch-format.html? The
main point I guess is that we don't want to have the "Hi," and
"Regards, ..." stuff in the kernel changelog.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-4U6WergtCmov3LiPXLSN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI5Q1hAAoJEKVg1VMiehFY1BMP/jD4hHkzOHJ/L6xzgsHapVMv
DoB826DWXX2g10jJLQGMyUDsyfD3QYBhvamwMAt+3XwKt3hBrIxe+duJ4x/pb6U1
Wt9YNE8CqB76p6QJKREaMjymTOQo38a2XW7x0HTLtK+XPqB9K3AW9EbdoFwyBYSI
U2lQpa3XoLgjb8EVk8J7AjdyfSpUzWIzqiwLtdIUQan83iuT0YY0KkLSikrQq1+3
1aLA496kUO4RzrAqa/cTXMCWHI9nvXorCWKUEF4fmbZZ71ZHmFtiJIxy7+EgvtTh
U59ufx7jDssa+1RiDqxznxwkBng33ZAoEHQKbnmw+5RX8Rw00BTCbCd/mRo/+6fm
6OrfPWmqvaA8E6C03bV8iHpClBNVNtCmCiuHZndxVz4G/1frCwhPorcgtdmAXfxv
CgjiemzhBtt1IbCHJci4jR9Ye9tDEECNzfWWaB6sipjmvTNOyIiapyNxUebTPbEY
+nC46w/Qop7B6A4nl4XtkWtYqsEgsJ2T9E5uYYDfP+dP7Ka2DyanaeGKJVzfFfob
RJ8vzq3B50aLbRwr0LA53R8OJ2Y1Lfsj7RGCayr/lNlsqldBz8jl174xTYYa7BVE
eHj94okAu6X3WGBi2L0UyQdQnShARabnmolpiSvpO42xSycEpspWi36eFOgU22Mo
JNllJ0Djwp2PtohtwuEo
=1dlb
-----END PGP SIGNATURE-----

--=-4U6WergtCmov3LiPXLSN--

