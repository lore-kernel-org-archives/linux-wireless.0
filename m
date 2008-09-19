Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43210 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYISORx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 10:17:53 -0400
Subject: Re: technology preview: scan with cfg80211 (v2)
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Dan Williams <dcbw@redhat.com>
In-Reply-To: <1221830207.12059.10.camel@johannes.berg> (sfid-20080919_151730_930583_57949476)
References: <1221794329.10419.9.camel@johannes.berg>
	 (sfid-20080919_052010_602864_D520EF40)  <1221830207.12059.10.camel@johannes.berg>
	 (sfid-20080919_151730_930583_57949476)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lz166cEeaHDlbpJnwXXt"
Date: Fri, 19 Sep 2008 16:17:18 +0200
Message-Id: <1221833838.12059.17.camel@johannes.berg> (sfid-20080919_161757_939682_A433BA97)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lz166cEeaHDlbpJnwXXt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +struct cfg80211_ssid {
> +	u8 *ssid;
> +	u8 ssid_len;
> +};

Don't try to do directed scans for SSIDs with length > 0 with this,
it'll crash. Update on my patch dir.

johannes

--=-lz166cEeaHDlbpJnwXXt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI07RrAAoJEKVg1VMiehFYTTQP/1VrftG/GfJoaUU36LUzH28T
FmpIjXBcOohu6XtW3DX7eoFIBzVFymIQUIgZ5Tync+APg1ukHp/qy7OXAnWn+R2A
W0EhdzurjeUa10ygdVpitMCaa3w1Yk6FHqTRD82t33i/3qoqOSnC+rfvRmJerDSZ
l2F/pznPOH/DbUGl2Ekg/Y3F3X58jhl4MlLIlcGv93EP9dgGysF92WoQuxCuwOon
wgvgwzfQ1YbEMSUbrKiG7zTj5aHnxa3NkWRLoqf4oZ23hc2CkeyCFbuZ0WmYtTK5
b1iJgDq3ekNM5mLnPKLDbcwD96Ar2OWSDpqBhhKj2JedMRFChRtSAO9nibc6SFpW
CQxJz3ClMH0lS1AADcVnfAQyhvwclmMOBzTAqfKGgWG0qcj3ybLX3SI7qPGTrm3D
C4RppXT/MobNPZK02j9RKFd0CwR30PA07wmrzV2Z7jJ3ucMy3D+25zIlFs0Diomd
ArRnA2HPfdM38U/9r4AViQnNvkU69MxpudfgSW07Cv8jhnPpYFZR6IAHoyLG+q//
3oinXLf5IXJAKfyFEFdNof1Nhhk+qLlZI3y/G59JVI08r5JM3BjCGxC5xUiWk29L
QnA+IGMXJB0QPzVLR/QeF5LHoh6ZJBIf7St2HfbGtT0wP/FBvSTaRL+xdLtCwQLY
DKUnJ+kO7E6lhQdjd68e
=X68I
-----END PGP SIGNATURE-----

--=-lz166cEeaHDlbpJnwXXt--

