Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbZI0LPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 07:15:17 -0400
Subject: Re: 2.6.31-git wireless broken
From: Johannes Berg <johannes@sipsolutions.net>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0909261631110.4336@sister.anvils>
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
	 <1253813740.3868.324.camel@johannes.local>
	 <Pine.LNX.4.64.0909241859020.25022@sister.anvils>
	 <1253816614.3868.406.camel@johannes.local>
	 <Pine.LNX.4.64.0909242036270.7469@sister.anvils>
	 <1253856038.3868.500.camel@johannes.local>
	 <Pine.LNX.4.64.0909250838420.3783@sister.anvils>
	 <1253868214.3868.713.camel@johannes.local>
	 <Pine.LNX.4.64.0909251506260.11390@sister.anvils>
	 <1253970049.5122.31.camel@johannes.local>
	 <1253973831.5122.33.camel@johannes.local>
	 <Pine.LNX.4.64.0909261631110.4336@sister.anvils>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JnPdICGDojVXK3hNsT3m"
Date: Sun, 27 Sep 2009 13:15:18 +0200
Message-Id: <1254050118.3958.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JnPdICGDojVXK3hNsT3m
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-09-26 at 16:33 +0100, Hugh Dickins wrote:

> I do have CONFIG_WIRELESS_EXT_SYSFS=3Dy,
> and I do have /sys/class/net/wlan0/ containing various things,
> but I don't have any /sys/class/net/wlan0/wireless with recent kernels.

Curious. I found the problem, but maybe nobody else complaining before
you means we can get rid of CONFIG_WIRELESS_EXT_SYSFS quicker than I
thought ;)

Will post a fix later today.

johannes

--=-JnPdICGDojVXK3hNsT3m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKv0lCAAoJEODzc/N7+QmaWHMP/A48kM2eSlJ1U7vEn993UE0o
XWNpiOOF2LQx90Z52SeSzackXWcoy/zX/jcZUEsh82aAfVezo2LAw3hR8DELC+yt
Xn2hkh8/PiNtV7dUfAIwhGB3ceNAFLaYvjHSeozxAOGtagWWveKmxo2YEhGSaLXh
oItAkcff14EGSVUgy8Qlapr8zrGga0GAIUOZJ853kQCZAuu9eJmGy93HDTIYwqt0
Z4YIHfTGmLyDFBg/j+HxHJs6Z/A3Kx5K+YvHnd/U4IoHYuwsGH1G2pqRilOLFr1W
GhG53UGUkxMQEtUAMhGe+Gmog6WaJ6nmcMMaxYKxVOoZtqCocqbYXXxPU27XOlVO
RbUcwjAOUIvkew44iM3OurXTbMF9DmAvxlugdrOAbJeaYOJ0cITkNreFS9TfObzx
y1+iw+lODJWjBOJs5uoU4FiYIHMXssVvGbZdHJEFEXI5KX2tNKuqKQK6qeMq48KQ
jKE5Mw1RsNO24gsfisK+5GG6T3dpKDHK+KnTVV5/J61kVGk4hPbWkQtWFin8urj7
j52s8Lkh7/8BKNstMttumbNLQd8pWn7SWVyuiJf0A+5RsVVcuYkeXjCJJ4VWPBDF
sQspW4A935+eiGlV4kjMNdIX1Pd+uCdcyLnwhY88u8CdNVXt+PxSHwxvZeVgCKbd
o1tx46QcBTgy+5CtsQcs
=yvDK
-----END PGP SIGNATURE-----

--=-JnPdICGDojVXK3hNsT3m--

