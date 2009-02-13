Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51220 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbZBMJNm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 04:13:42 -0500
Subject: Re: [PATCH 0/6] cfg80211: adds a workqueue for regulatory hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-N18RokWAg6tuglN1pm50"
Date: Fri, 13 Feb 2009 10:13:14 +0100
Message-Id: <1234516394.26933.0.camel@johannes.local> (sfid-20090213_101351_317215_5EB03F03)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-N18RokWAg6tuglN1pm50
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-12 at 21:35 -0800, Luis R. Rodriguez wrote:
> This series does prep work and then the actual work to move the
> cfg80211 driver and userspace regulatory hints onto a workqueue.
> It should cure some lockdep warnings and also pave the way for
> more future reg work like beacon reg hints.
>=20
> Luis R. Rodriguez (6):
>   cfg80211: rename cfg80211_registered_device's idx to wiphy_idx
>   cfg80211: add wiphy_idx_valid to check for wiphy_idx sanity
>   cfg80211: rename cfg80211_drv_mutex to cfg80211_mutex
>   cfg80211: add assert_cfg80211_lock() to ensure proper protection
>   cfg80211: make regulatory_request use wiphy_idx instead of wiphy
>   cfg80211: move regulatory hints to workqueue

net/wireless/reg.c: In function =E2=80=98ignore_request=E2=80=99:
net/wireless/reg.c:1067: warning: =E2=80=98request_wiphy=E2=80=99 may be us=
ed uninitialized in this function
net/wireless/reg.c: In function =E2=80=98__set_regdom=E2=80=99:
net/wireless/reg.c:1513: warning: =E2=80=98request_wiphy=E2=80=99 may be us=
ed uninitialized in this function

johannes

--=-N18RokWAg6tuglN1pm50
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJlTmnAAoJEKVg1VMiehFYXZUQAJ1XKocYuED7GNKzqoHk7XuD
uHQGwDIkdodf/2+DIW49l16zmOb3RmkX5YCcoZLPkNFMU0E86EAr0YrQ0wOpE9Lr
krPwXu4/tQTEvXn5aL3UiGzOsx57x2JGM2IpHIDY1lhMeIfM+tSNy8ps82cwFeUW
4W/ZfshJAaDfcQkefM1+36/weow5ccWghJkai3q7I5LfuZTa24+PTNr8EzVWVhn6
gGcJlsi93I7rdORL7b3KfPp2h6yM/T8nxJ22R8PwkwxoklCam27+Vspehsv60QrH
zZ8ayOf1sY+afEMnnwEiI0bxPW/u5bq99Vh9bGPqwokofJc6GLd4hQCvjIpS6ki+
CPBIxFVl/6CGLUnQ65SNtRq9/jTtZeX9mrffXEf1z9ntrVIVx1ynFusWVyUuaNcP
z200FCB8CBxessed9QXmsBp4Awc/B0Sg4Sq6S+0CVXx5ABHi7klJRmTQlcavJ8av
byk1NRsg3BG6mSPxJSYUjIIKONEeGex+/D4x60aqwsuakI2ZG+kMddGZ9qiXoVAA
9pNDpyq4mDmyBj5hC6M+JVPmuDGZsJRBkKuU6jY7PCinbhq+EYfhmAyL4fjNjlL3
qtXSXba08kOWVHlbqt7/dAm7s3a/kvuM+hSQUkAIeR4ZF+mK5m61NuxFHps02LmW
T9eSHfSqxnGHoT4h9uG6
=Mjd5
-----END PGP SIGNATURE-----

--=-N18RokWAg6tuglN1pm50--

