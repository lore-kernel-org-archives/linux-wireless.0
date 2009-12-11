Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758349AbZLKN6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:58:31 -0500
Subject: Re: [RFC] mac80211: disallow bridging managed/adhoc interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Markus Baier <Markus_Baier@web.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20091211T141516-495@post.gmane.org>
References: <1258465585.3682.7.camel@johannes.local>
	 <loom.20091211T133913-639@post.gmane.org>
	 <1260536425.2442.199.camel@johannes.local>
	 <loom.20091211T141516-495@post.gmane.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jy2N2PRsiL2R0wkaZnAS"
Date: Fri, 11 Dec 2009 14:58:36 +0100
Message-ID: <1260539916.2442.258.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jy2N2PRsiL2R0wkaZnAS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-12-11 at 13:18 +0000, Markus Baier wrote:

> So I will remove the wlan0 line from bridge section
> of the gentoo net rc-script and hope that hostapd
> will take over that task.

Well you do have to configure it to do that, but that should be one line
in the hostapd config.

johannes

--=-jy2N2PRsiL2R0wkaZnAS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLIlAJAAoJEODzc/N7+Qma/FgQALZyg6FZUvEtiMN2aothwZIY
uyF+INrd71t0DL3fVdnm2r00k1GRggg4XL/JE+/yZ1gQvKCCGp+NgEhg8XvssYlS
2oJq2v7lv/HvYKn5Ziwv8UIX/efdGdcz2N4pG7XrkcHowaKHVRreN1eBFOVWDXzh
O5uVTQCS3Y/14w7B4yml69v9/+COoV2kXidQo8uSIWxi/7Tt11ERDXlAO2wFIk+g
rOUnLTTUum/BU8Zvh1Tizk1ktRZpw/CLoFUlJpbPNc1aPQYiBq1mwULAtotMSiKe
jpu9jlW/PW4oFvpqlrJvlhevN8n0ZVucoz9WckRQEZRzfW3pVGL6HJTxnFo1mkD/
RgQuXAiVYt+NfsdojlHE70CB11NxnLXRUnmHjIDLxjRtKnKDhgAGD4EXvlsvn2EF
reZ3Cvd4uOM8yB9+/Y9tHJzJX8fAJvhzWnS5kyvPI0mFpbcw++1XlB6RHNlHRYk/
10CIK0dTACbaanrIspnOI9U0gIzQ1aTy4jihWf/fCdOw5U4ZUr71AnN+5YQjvUkG
Fv7kO/yEq1O32glHeYmUeZMb7T7hqxnvlpR8R7aF+Rw//wIdPB1UUyI9Qa8zj//v
CxIBJ3nDGNSgRLmKg8UhUoZLmaiKq5ew//uUEFTNNTcIsuIJCmN6fK2PYcyK/8rS
CnuqM/NgI0BHB8Jb+Ins
=ZMx+
-----END PGP SIGNATURE-----

--=-jy2N2PRsiL2R0wkaZnAS--

