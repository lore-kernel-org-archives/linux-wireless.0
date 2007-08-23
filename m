Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44843 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbXHWQA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 12:00:59 -0400
Subject: Re: [PATCH] Add iwlwifi wireless drivers (resend)
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <1187328536.5763.137.camel@debian.sh.intel.com>
References: <1187328536.5763.137.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ai2DUR9bcNxhy6jUK0TT"
Date: Thu, 23 Aug 2007 18:01:23 +0200
Message-Id: <1187884884.22725.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ai2DUR9bcNxhy6jUK0TT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 13:28 +0800, Zhu Yi wrote:

> This patch (against 2.6.23-rc3)

+#if IWL =3D=3D 4965
+	modes[G_11N].mode =3D MODE_ATHEROS_TURBOG;
+	modes[G_11N].channels =3D channels;
+	modes[G_11N].num_rates =3D 13;        /* OFDM & CCK */
+	modes[G_11N].rates =3D rates;
+	modes[G_11N].num_channels =3D 0;
+
+	modes[A_11N].mode =3D MODE_ATHEROS_TURBO;
+	modes[A_11N].channels =3D &channels[ARRAY_SIZE(iwl_eeprom_band_1)];
+	modes[A_11N].rates =3D &rates[4];
+	modes[A_11N].num_rates =3D 9; /* just OFDM */
+	modes[A_11N].num_channels =3D 0;
+#endif

What's that? Poor man's attempt to support 802.11n with a mac80211 that
has no idea what 802.11n is?

johannes

--=-Ai2DUR9bcNxhy6jUK0TT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGza9T/ETPhpq3jKURAnkpAJ9XUUF/XMEhHNpKAhvhF//rUGsrMgCcDb/Z
tXipoiJEZhLBpeY3y/4luuA=
=sIL0
-----END PGP SIGNATURE-----

--=-Ai2DUR9bcNxhy6jUK0TT--

