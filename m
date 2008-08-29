Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50109 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYH2TjG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 15:39:06 -0400
Subject: Re: [PATCH] iw: Add support to send a request to set the
	regulatory domain
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1220032919-6821-1-git-send-email-lrodriguez@atheros.com>
References: <1220032919-6821-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/VdSYqkRE6wDiDwHF4a0"
Date: Fri, 29 Aug 2008 21:39:00 +0200
Message-Id: <1220038740.25321.39.camel@johannes.berg> (sfid-20080829_213913_077881_803B7C82)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/VdSYqkRE6wDiDwHF4a0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	genlmsg_put(msg, 0, 0, genl_family_get_id(state->nl80211), 0,
> +		    0, NL80211_CMD_ASK_SET_REG, 0);

ASK_SET?

johannes

--=-/VdSYqkRE6wDiDwHF4a0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIuFBRAAoJEKVg1VMiehFYS/4P/25MHvFQqCs3z3sjLjtaYt/j
TtWMigDHChLJIZt5F20y0kG/LCVpXqLrKDgu3eFeU8vznAjoO2AKZTNMGIXR03zg
iJ8fPPOOKsiENHdWnc6Wl4YvjlR3pRet3QLvH6Ajd4u+tNuoGWyrKOWfqsXl0l4+
LzdICWyKkP7TBJV4clONv+QB6yluO2SOwbnt40+q8LC4SWHsSxSCypQQoGVjHE49
CHCvcveE4ZD3xFXqgV+GPPC3lEI1N18wahvWSYUCGmKZj1gNQvU4b6qI+E/P8b1K
jLDPxrkHnZJbUAbO5lGFqB54yOBwq4N8hATJBXAeEh7WLRCVDdv0YPw6LukOaucs
ztmru6xizJJKL6eERuiQnk/yCnWTmM3Z0yJpuXtd9Dos9cJvfbODtU8JTSTusmuw
vgqhPYTojwEvODKndQpHlbTCygOwXATzCqruHwv+EGeYYrk1gPLloiyaZJLbLrHs
/5qH5hCY0a8avX6fqQ1S6Thlh19OECXsQs9HETY5d293mTF5F2ObeTJDkTtiZwkt
JRfbBBDN+z76d83rh2JryOZDEuRdNXD/PYAd2m46L6JduClMQk4d+YBSpk8ZQITL
SjUnx2WAqcj+KUAGCVoqe7kr+kfTx09bnuWTczFIZX8J4AY0AlazTuS9Ct88q9u4
w1scdyFFANkEOrbqS2Gj
=KTEo
-----END PGP SIGNATURE-----

--=-/VdSYqkRE6wDiDwHF4a0--

