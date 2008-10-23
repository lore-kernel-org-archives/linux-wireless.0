Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbYJXJrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 05:47:24 -0400
Subject: Re: [PATCH/RFT] iwlagn: remove pointless TX frame check
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223630089.3930.71.camel@johannes.berg> (sfid-20081010_111517_870111_CBA3F26D)
References: <1223547733.22490.43.camel@johannes.berg>
	 <1ba2fa240810091308r167b9147p46f74421329a55c1@mail.gmail.com>
	 (sfid-20081009_220831_876301_EA9D5BD1)  <1223630089.3930.71.camel@johannes.berg>
	 (sfid-20081010_111517_870111_CBA3F26D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/E7xHKwZGxkh7868wgem"
Date: Thu, 23 Oct 2008 22:42:12 +0200
Message-Id: <1224794532.6002.73.camel@johannes.berg> (sfid-20081024_114728_369906_13A28C41)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/E7xHKwZGxkh7868wgem
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-10 at 11:14 +0200, Johannes Berg wrote:

> > NACK, the completion of association of mac80211 and iwlagn isn't fully
> > synchronized so there is still
> > a race.
>=20
> Can we fix that?

Ping? Any idea _where_ the two can get desynchronized?

johannes

--=-/E7xHKwZGxkh7868wgem
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAOGhAAoJEKVg1VMiehFYEfMP/2wSQXXY7ryEnrIRRMs+RIWB
M7n+sj3O6eVqAKmcIgp1bjrMao+tuKVtp/HB0/A8kyCTvfBDsoD85aS/ue4mlM06
kXNY8xSXhRp01dffprlpGmfQ0wqEkdKETTIe9BaIUOYJkI4cVdx897xqCaHeVX6U
GXKi23xcD3UvjwhXPkjqhzCoZ9UhPih8vHux2aIDYFG+/jeJoyNQZSOUb2tDbHOZ
+GlbCguyihMV3JLYVCK2MW8vVixVeqS3HVZxLTbfhynva+59CcPYxYbUZINBw+tP
lZY7UwdbnTwiF9gHILDbSOrNxJziPA1LW2DPyFvifh5K3snZ60iWk4PxkzRA0r/J
274/WdHM+1cpGKu9VRjcHMDJSf0fIPnfBf0woiGhrB4uavzhTH+zIKC22rw+HhoQ
E4js42QKOcm9m0/GriwhliYSiDNU2cwMsw+eyTIk5WvWQ8eQ7GqFJbgRViGqbDUN
u978/bqADB70bjDUugWbw/Rmqiv+9hXa3AD70WPDj1ewSIPbVEMBMKCHxf4dIzW0
uzDt+0pZtoKctmom4FmNMpBydKCKwCPhBWMCihq5esdmXZ2DHPfaYIf1+QsTW5VW
MOQg2EXRsZcvKXb/ST/4bKXE0aJwRvXOkGjjLusx8MXUach9GoSTBcTzVvrjg3KR
j7ieco877LflXH8EBGXS
=/1bV
-----END PGP SIGNATURE-----

--=-/E7xHKwZGxkh7868wgem--

