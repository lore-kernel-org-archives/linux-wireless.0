Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60530 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbZHKL43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 07:56:29 -0400
Subject: Re: diff --git a/net/mac80211/mesh_hwmp.c
 b/net/mac80211/mesh_hwmp.c
From: Johannes Berg <johannes@sipsolutions.net>
To: David Woo <xinhua_wu@realsil.com.cn>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org,
	andrey@cozybit.com, linville@tuxdriver.com,
	devel@lists.open80211s.org
In-Reply-To: <1249986145-6531-1-git-send-email-xinhua_wu@realsil.com.cn>
References: <1249986145-6531-1-git-send-email-xinhua_wu@realsil.com.cn>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-44Z7eO2VzkMZBOl2SnZ1"
Date: Tue, 11 Aug 2009 12:50:06 +0200
Message-Id: <1249987806.5705.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-44Z7eO2VzkMZBOl2SnZ1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-11 at 18:22 +0800, David Woo wrote:
> static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
>  				    struct ieee80211_mgmt *mgmt,
> -				    u8 *preq_elem, u32 metric)
> -{
> +				    u8 *preq_elem, u32 metric) {

And other than adding this coding style mistake, what does this patch
do?

johannes

--=-44Z7eO2VzkMZBOl2SnZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKgUzaAAoJEODzc/N7+QmaxksQAJ+zIYZLW9LFS03zVU7gAJR+
qW+USLAxFE2q0r2R75DMLP54Hoqd3GQ4e/ijy9hncpXjzcaVbD0zm/bUBz+a6AzM
vxT2m+Gg4gb2pdZp2mp6w8F9btSqCMQ5BimNZjqMJ937EDJG/ejTBfNluvRlD5G9
vqFRYNwA4ZPlUCX1E+quNxF/pr16TUhttSqxV7ke11i1VXS2mJqaqVIPgSAZ6uER
OWOdtR6U7mdlFs+fe9A5nLBAwn6HQRN30is5HeOHKFq2xqgAE+S5IRS2JE8sPCtg
X+mOW2BA28aUkp2cd0YVM8YCTLXH5j/CsqjLi+KnTflVXmqWZJWQGtY8XJBJc5En
JhxiOhW0J3AiPcpYJC+q1qHpvkAj7sXlnuEWbN0AKXIeBjiWK+rgPJ85piH3Lue/
YSdcyDDguXGwm6qQBtw1QGG9WtBljtuJAFbgDo3+FgTkDRkctf7gQE80lmofnGxZ
mfpWs6e9sAZo+oiBHpWWheEKocJt6WORPWWn/SoV67VrGTeaY+7xB2+kUrbZdI+A
0glsCJxz1dXBFXFcBjFBLYHwdoTauN45dG9H3UXDzjedp/wg1Whzfz7x5ncMBLZ/
6SeC4P2DaOvf9AckDU2FfCP3gErdsKWJuz6qkpIFLTBD1nzbRDoIbx9AtckgWX4g
oCbuF2RGLQJGbaKNVbsF
=NJG5
-----END PGP SIGNATURE-----

--=-44Z7eO2VzkMZBOl2SnZ1--

