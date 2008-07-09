Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52200 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbYGIRlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 13:41:32 -0400
Subject: Re: [RFC PATCH 0/7] IEEE 802.11w / management frame protection
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080617154008.883383150@localhost> (sfid-20080617_175912_673335_B33F2037)
References: <20080617154008.883383150@localhost>
	 (sfid-20080617_175912_673335_B33F2037)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VGLOkstWWcAl0qyBc9iN"
Date: Wed, 09 Jul 2008 19:40:46 +0200
Message-Id: <1215625246.3246.40.camel@johannes.berg> (sfid-20080709_194135_916590_FC9A6131)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VGLOkstWWcAl0qyBc9iN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This patch set does not address the issues found in configuring default
> keys for monitor interfaces, i.e., this still needs a workaround in
> hostapd to set IGTK for both wlan# and mon.wlan#. In addition, the
> debugfs directory is left behind when the monitor interface is removed.

Can you try this patch?
http://johannes.sipsolutions.net/patches/kernel/all/2008-07-09-17%3a38/021-=
mac80211-inject-sdata.patch

It should use the sdata from the TA instead of the monitor when treating
injecting frames, where possible.

johannes

--=-VGLOkstWWcAl0qyBc9iN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdPgaAAoJEKVg1VMiehFYAhgP/A00bSl6wrZigk51fAoqqRxj
x7p5i6b1OimSrCcMehVDnGCB5x1fIE9qdnlGtMEB1Q2La8nGRtWalPq0GAI9IJhF
v50VVZ5vPQ4Mxm2m6z+solN6fJzrbF5UV8A0K4Z/pWlfV4I6f7HBNN21suTM6PfG
QJVFz6RbMVQLg1Q21wVm3wC0CTmSDcFCz54tLgx6+D8Aj/4+d/czOk6pFbnzx6vj
5zE4e7P7jzLoMgW0lqo6fkBGHfEuoC/HX12+okkvVNDHT6y7MwZqLL2X7ZMr7jUG
iyE1oT0/dTdz41cyz1sr+3JBvyfXQz9mzc/rFyzfEgxY4r1nq0BdgGVMstV88Fb9
pymDmQ+gsv0oxMaT+J3xMupUrR8YTIll4pk/Hi+uozxLznBdu2RlmUIaYcAWgw1f
ppIDXA72Rj86deFwFlv0AXbLed+rM+qyzku6PRXLv59MMT3qXzMJ4nGxUd3Th3Gf
zFpHacTouaZKDfOwkthPMX2lafxet27igKYEBoYkT8sh8qywc91GE77AU1WoQXtW
yigU+fSf6YWEUdvkSwx3g0CMi2le55WHmJXHHdShN6ljytpKZJYST1G54DAzG2Q7
5tgqbUD63eti8FUMqanzaqAPMKIR5kM8aTsBruVqWXBA+bt4KOF0KpSvdUdZ2X9Z
9d7u+BR4//LqMRejAZMQ
=FQcb
-----END PGP SIGNATURE-----

--=-VGLOkstWWcAl0qyBc9iN--

