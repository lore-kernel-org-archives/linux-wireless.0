Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbZI0LIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 07:08:44 -0400
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eKFvZla9b/xy+rDtjTeu"
Date: Sun, 27 Sep 2009 13:08:31 +0200
Message-Id: <1254049711.3958.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eKFvZla9b/xy+rDtjTeu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-09-26 at 16:33 +0100, Hugh Dickins wrote:

> I do have CONFIG_WIRELESS_EXT_SYSFS=3Dy,
> and I do have /sys/class/net/wlan0/ containing various things,
> but I don't have any /sys/class/net/wlan0/wireless with recent kernels.

That appears to be the problem, though I wonder why that is. I'll look
into it.

johannes

--=-eKFvZla9b/xy+rDtjTeu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKv0eqAAoJEODzc/N7+Qma9PQP/1JI1iXikmHMQkF88QlsVJdY
TB74TbWJCEO2c3TKJzFAxPSfas1rZztE3E3BgB6p7dByBdwSjNwT5u6b20kD0xfV
2lU75cC9vet0KSulbvJjt+tXMoDdHeXH8FWgnhtPv7Im1Y+RUZdU9aqf2UhWgxwN
oeffyIqhDwghpbC2oNdp+6OyTLlaqWcUWAWL3QU6zaAKVRAJ9MOhLuw1z7mF99FR
8nSGjOHxsdAE0dGqA1SANvpWGLmpdV3eF5urESnXMJoCONVs0FDdfARY4HeUE7l/
uYlq1yCCS6QGEmTG+rnqIxbAqSwtzVD9YPgKTdow2MBP0ayyleLD9yiYcFT2me3F
P0Pjfgd7fTvotcfbkRJFR1IKaVJE191oqksHxDg5qcfKtCLU4g5FYsO4vVfYDsEe
fxU0ffeI0lCTr08KaVn9aUfbZPQ0tyP91E21WYB5KhWDH+T2Tu2h6VfwNLLE9GfN
1sMLCuRV/MKagjiWNIe9os6MJiD7CMJqLgDdf2OxqtyNfXEV1W69VVR4Y7kFncgI
7kFZLfyNSqnLJuJiw7ciwY6gWyEsI797iUCk5t+whpK2K1y+MBZwV59Eh3/xJYhu
HC4meawQ/DSRdEu31WoVzKLs1dW0SEfAiNYsK6mHj86MymRKJFVWOjyLFtssg4uO
M+POEnX11mJ1ih3YXvSA
=uUsH
-----END PGP SIGNATURE-----

--=-eKFvZla9b/xy+rDtjTeu--

