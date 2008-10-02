Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbYJBN2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 09:28:03 -0400
Subject: Re: [PATCH] mac80211: remove redundant check in
	ieee80211_master_start_xmit (net/mac80211/tx.c)
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <eb3ff54b0810020556s407728b9n772e7ae178761eee@mail.gmail.com> (sfid-20081002_145638_432332_195D186E)
References: <eb3ff54b0810020556s407728b9n772e7ae178761eee@mail.gmail.com>
	 (sfid-20081002_145638_432332_195D186E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MjqYTNT2225RnBEx3pjn"
Date: Thu, 02 Oct 2008 15:27:11 +0200
Message-Id: <1222954031.24551.51.camel@johannes.berg> (sfid-20081002_152825_816869_BE4C7CF0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MjqYTNT2225RnBEx3pjn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-02 at 15:56 +0300, Rami Rosen wrote:
> Hi,
>=20
>  - This patch (against the linux-wireless-next git tree) removes a
> redundant check in ieee80211_master_start_xmit (net/mac80211/tx.c).
>=20
>   In this method, there is no need to call again the
> ieee80211_is_data() method; this is checked immediately before, in the
> "if" command (we will not enter this block unless ieee80211_is_data()
> is true, so that the "and" (&&) condition in that "if" command will be
> fullfilled ).

You should un-indent the code accordingly.

johannes

--=-MjqYTNT2225RnBEx3pjn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI5MwsAAoJEKVg1VMiehFY848P/3gaq6Veg+BxF6mYbvMsdPKp
jfalP0zi1FkEZqDCEU4ZdRAtpGvmPA++Sy8nf+CZmzkVJiAd8f26J37Tcw6wgNbF
PGvJevpRP+6lmheYjQoMlIUXFtrlxlANQ4RVEiP1sN2TM0vYImZ9WEvJJJSk0kKk
XYDbZ2OennxErDiEBYPPc68xisVxRT1RZojYX4SVhao7atv/rpcYumbPNaAz7ztK
T/WjgraV4cYbwwJ5HnQ38E7ux53ndmGQEK8fXaaoorHkXGDM/Y+1a8gYBwA2f0kw
mS8kHpSR7V1s+qRJVQcxHqDusGDnoaWkpnrif+Y4dHe0E0nzdQmVIuo5MHyxAr1P
iSsEFyXaATOQMsMROH49AcWiWMnDwSDXPcx1K3J+FxqTqGFkVN1bXxcMsKUL2bk6
+Hd45xEs+0MFHREuPeP1qPPtbSDsQUCsZwnl2KzedVAlfEQl9cDnZY9A33qq4iim
qlQdEZ1iqONawQfzrYAmHmoKnvE8n+AkXQn1Y0DPkKbTVDgXdE3Fx6X10LeDg2Pa
VxePZRz8HQDG6T3lSK8MRcTkRI6h0XTDoyzPoruLxaPP60UblYgLa1zgix7CU1kv
R2qMmsVHgWCNOLkeCGgjkCLjNiuSIWu17r8pCh66vx0Vd713uPm5nY0F6PabKsLg
xVKxuBMVPjzr/6QAaZVJ
=XJxz
-----END PGP SIGNATURE-----

--=-MjqYTNT2225RnBEx3pjn--

