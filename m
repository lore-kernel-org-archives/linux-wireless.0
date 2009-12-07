Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32772 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbZLGHHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 02:07:12 -0500
Subject: Re: ssid
From: Johannes Berg <johannes@sipsolutions.net>
To: Bharat Bhushan <bharat.b.bhushan@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <d9360e520912062221o1f543bc9tbe3813113562a25d@mail.gmail.com>
References: <d9360e520912062221o1f543bc9tbe3813113562a25d@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IwVdUY/NHe7fssmNNN8H"
Date: Mon, 07 Dec 2009 08:07:15 +0100
Message-ID: <1260169635.13866.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IwVdUY/NHe7fssmNNN8H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

This change happened because no driver required the SSID, and many
drivers were using it incorrectly. I'd be happy to add it back for an
in-kernel driver where I can see that it is needed, but _very_ reluctant
to do it for a driver I've never seen. So please add it back in a patch
that you use for development, finish your driver, and then when it comes
time to post your driver upstream you can also post the relevant
mac80211 patch. Oh also please don't develop against 2.6.29, it is
_ancient_.

johannes

On Mon, 2009-12-07 at 11:51 +0530, Bharat Bhushan wrote:
> hello gentlemen,
>=20
>                          i am trying to implement an open source mac
> base driver with kernel base version 2.6.29, for association
> completion my hardware requires an api with ssid to be sent. but i
> could not find any api from mac80211.h which contain ssid element
> except hw_scan which i cannot use as ssid should be sent before
> association ,few days back i implement the same driver with kernel
> version 2.6.27 and i use to get ssid in ieee80211_if_conf structure in
> config_interface api but now this is deprecated , any particular
> reason why this change happen, is there any other way i can get ssid
> through any interface.
>=20
>=20
>=20
> Any help is much appreciated.
>=20
>=20
> Thanks
>=20
> bharat
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=-IwVdUY/NHe7fssmNNN8H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLHKmgAAoJEODzc/N7+QmayZMP/ityQ6JmCZ+qnRJQ4V4zpp3H
dBDAlO7dqhFzRIrqkqhlyT3N+B+Gp6MPdJgvHDSKw21gY5klM1m11mmy/t0mHYnP
EYiPyJkRGeoCj1FfHSLENLPFou7ile5cG/piLfDbM+q+AeeYWH2mrBrvsAKOEyv0
joEgA/1zdvfHz+3NlmZRgc3bB9df46YlJsijYkAf00bAOI38gDbxEI6nVkYL4FrE
Iur1vAwQAywJ1v27TUl8+tV3xbHNd21ml0sQwHut31Tc7rW5I7kzFDbKgMQCvTH0
BfRN3Y8O86sHzAzj+ADZNN4MEqD3R8iHG73AXCnkxBVDFu2WgAWcLgkxaa+7VzLr
TBrLLGpNVR44/BFrn6IZUJsauanM/fKTwyFMCfd8lOfN6bnfK+9sPD/PGKIihhTu
zd0PFaChTU8ZnKaJyig/l+pSUAPSx02C/eVJsTfg+yRw/N7nkrijXC2k5OrSIRbK
BFUaUsLiB0J75P3Eykwupou1fLCaO1b4gA+X3IGNN/p/J6rQnkyt0KV1uac3N6uH
bHNxQcvB83hAFVOXiTmIVkknBRNPwbjTf4iOCL5CXDFrpY/MomCNMTDlCzdjkATW
gRdKbgdNGz4aMqiKIbpkcJ3euJuux7iAKPucWdt/6VCrtB4b3xtOLfzXRLToekLJ
o29itcdeRz2bbM/bLCSi
=xVTD
-----END PGP SIGNATURE-----

--=-IwVdUY/NHe7fssmNNN8H--

