Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZCKQGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 12:06:42 -0400
Subject: Re: configuring while interface is down
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: j@w1.fi, samuel@sortiz.org, linux-wireless@vger.kernel.org
In-Reply-To: <20090311155812.269850@gmx.net> (sfid-20090311_165952_043610_1F5C5846)
References: <1236774973.20266.13.camel@johannes.local>
	 <20090311134329.269810@gmx.net>
	 (sfid-20090311_144435_584837_2198C4E4) <1236779314.20266.22.camel@johannes.local>
	 <20090311155812.269850@gmx.net> (sfid-20090311_165952_043610_1F5C5846)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QoZwbvVsLD1LydlbDV+w"
Date: Wed, 11 Mar 2009 17:05:06 +0100
Message-Id: <1236787506.20266.28.camel@johannes.local> (sfid-20090311_170750_121417_0796C36E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QoZwbvVsLD1LydlbDV+w
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-11 at 16:58 +0100, Alina Friedrichsen wrote:
> Hello Johannes!
>=20
> > which is what we'll continue doing in cfg80211, but I think we shouldn'=
t
> > bother the driver/mac80211 with it until the netdev is up, and thus
> > reject things from nl80211.
>=20
> Do you think WEXT should only be a wrapper around cfg80211? If yes, I wou=
ld agree.

Yes, of course.

johannes

--=-QoZwbvVsLD1LydlbDV+w
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJt+EtAAoJEKVg1VMiehFYSrgQAMaKD90MPeG34gg+60N+sF9s
3RXAjav/jH9zbsCmaxXTAdOGo5Yt0D9T23w5w6kdW96cLB9s7yh2ZrL287RUPhou
hwwwFXUUTDq7JOtMZPzUSECjjVy2GFmu2uAxmRqunN+IYafVAsehdPNjVYBFzyZi
A/90erQtLNDHUYROepmb/gfqlK3MwJkvHZxYi2izqeuYdg4CvjiZMc6pkYgPZWW8
axIFceg4oHWBviKILl9JaKw4qknQuccToQBJLMznmpmZIJZqAXHHk3GxoGg7QPMo
Rrp5dvxzRIlcYoaKFDR8A1OeUMQJ/9busi5w4XsAgLY20+HCHJd3tR5vQNp0dfpl
NjKqCJMKmlgUEE3jOTwQW+ZISvSyyf3guVw0sTCpx3XVIOolqWkl4gC8XKEoMEhN
OYZrk0hPcYExvMN6Xc7IH2ipcG4xyx26OJvw+/XiNmKLo/EvEhqDFHOYCjKZrmGM
itWLP/S5fLpDfZLhqmgPt7J1lEtUl81mEN3SJv124XgQ0Gq2oEJBF/8VMrn7PZOd
ZUPS5wQnIh4w+OC4ruI/d3pG6sUVAR7wdthLMjJU2Y5bzxlLq7JZiTuR6+kyDVC5
098TV+CqFlnHBC9ANMXLb18yg2SPkaaOWe1LlgdfVRV3whSKuqEHxEBkoQL4i0Ee
FMJQw63NxcobXMpqybr1
=+yRl
-----END PGP SIGNATURE-----

--=-QoZwbvVsLD1LydlbDV+w--

