Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZBRVc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 16:32:28 -0500
Subject: Re: ieee80211_regdom module parameter for cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <499C7DC0.4040608@lwfinger.net>
References: <499C7DC0.4040608@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kfizLggx3fxcqGJh3g0F"
Date: Wed, 18 Feb 2009 22:31:52 +0100
Message-Id: <1234992712.4023.60.camel@johannes.local> (sfid-20090218_223230_825736_E7DFBB17)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kfizLggx3fxcqGJh3g0F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-18 at 15:29 -0600, Larry Finger wrote:
> On at least one forum, I have seen the recommendation that a user set the=
ir
> regulatory domain by creating the file /etc/modprobe.d/cfg80211 with the
> contents "ieee80211_regdom=3DUS".
>=20
> That works as long as CONFIG_WIRELESS_OLD_REGULATORY is set in their .con=
fig,
> but will fail if it is not.
>=20
> Should the module_param statement be moved outside the ifdef
> CONFIG_WIRELESS_OLD...? Setting the module parameter that way might not m=
ake any
> sense, but it surely shouldn't kill wireless.

I actually see no reason to not just /honour/ it by calling crda with
its parameter if CONFIG_WIRELESS_OLD_REGULATORY isn't set.

johannes

--=-kfizLggx3fxcqGJh3g0F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJnH5GAAoJEKVg1VMiehFY2NcP/3PpF5K4I/LoMlg7JgVJLi2r
JZfkEOMNvaxY2lniTK6JVQ+RF4qbdu6lzUPDoPCw1m8UQnltcM2hRR/YeaGlZgvr
lXVo36Caxmx2IQVZgUSmsyGFbYsBV+9VD+wb5JXQw0XMe4agQ5tllWkpD5FuSgFB
YGIwYQwiXT5+4of0iMpHMcSOdKnNIlzvQYRIAx7UqK7e67hqWYCSzuZIvVTLtuNT
jPQ3gwJqbxMRhfROj1po4tiaY5lcilh2XcLgt6VHhctKEivfZrczGG1fbFK1kXlX
icfGw7bcinRJmFd32EDLi1m/YAWz3D116P6BKrtHeO2qbQYbyZWF6lnnq2i+dsmz
1mflN4NaxC3XvpEXm6XfRCxA+2+/EOUanDs647QoZITs3Q/OewZg+x/BTFXNvXLV
b9e7UCQ6aTIrOwsmcjM2M3j8Tcyq4CNRT2FS5akE7yimSrwy+USQlU9dCx8HsbEZ
mzJRqCy/A2PNVcJ2I5saDt12+ORGk1ae0XWzKLHKj0SXEOAhgdSVJoRpl6tuagwv
6sVx2xEr6E7yreZlNU7JWxIjGHzQlKuvXatlVIzjPV0b1UhrlHGV0z6tlmJqIPOy
BEIv8JEpGjLfXlETzP38+noHxf1qeQZdy3p9/F7CMo/ysviHguwPEnm9A5WzRLVQ
VlUW1CnkM+51gDU9EocK
=wQxT
-----END PGP SIGNATURE-----

--=-kfizLggx3fxcqGJh3g0F--

