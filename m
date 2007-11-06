Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbXKFJy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 04:54:57 -0500
Subject: Re: is net/mac80211/ieee80211_common.h being used?
From: Johannes Berg <johannes@sipsolutions.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0711060136410.30254@localhost.localdomain> (sfid-20071106_064027_299099_72B25D2B)
References: <Pine.LNX.4.64.0711060136410.30254@localhost.localdomain>
	 (sfid-20071106_064027_299099_72B25D2B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x1yHUTuwiHyssX5JlKTx"
Date: Tue, 06 Nov 2007 10:56:15 +0100
Message-Id: <1194342976.4066.0.camel@johannes.berg> (sfid-20071106_095505_274536_28491B7C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-x1yHUTuwiHyssX5JlKTx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-11-06 at 01:38 -0500, Robert P. J. Day wrote:
> hoping this is the right list, does that header file have any value
> given that no one is including it?

No, I should've removed it along with the management interface. I can
send a patch.

johannes

--=-x1yHUTuwiHyssX5JlKTx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzA6P6Vg1VMiehFYAQKGwg//R1mEeLArEajczODlLPHZJB71QIziKgH2
55Dpa2KqY20U8PNmw+vqsZgW7+Lmetle285+oIRH5yXM1uwQmk3gcSr5tuosk0ji
92ilYdSitWOrk+wirG241ro8s9QfDdoOBnf/2se+6Km1Qsyl+CfePxphh7zt356m
Ao9mFifgtNH4/o9ldEHByikLg5hXC38PYNOFCTzjXVrOvv5c8TMA35MkjLoRSVch
NMBa7X5XPEoyDShw99owVJP24MGBgWzO/Z9AwRFLSTTMGAOUCy7CRTXNSoCnR6L9
sNunJc7RFm7Bqeo1ohRL0S3y0T49CrXFvHv7OEa+JkEAgv82knoFy6at/qz4qioy
UlhdUT1947k4bDbTWtcriqXrq7GjojFBAr30Z/6bOUQqeyxIhTIVtxULPYckNzZX
FLe6HXu7svrSeNvYxG3tv8klyx8RC5fY2ititJ51AvxlMfMiezYxhOuHExLymedl
5plPz9v90klwfyeKCY7SWOogKJt1bpTy0PQ9tTRGZwQuT+497lZgCYMKswrwqboP
RzHjwPKiqulU2JaQJtPjezhXUHe8rYuiPAycpXMmrU9ApHSCXyQEUfaBz/tX9sxX
+bU8vIMD/Q7myLzyhY+7XS1d/vTflhdFxWKvCpAAn1WNfXX1HrYIAdPUaKXyZiCT
tIzf1ZBKvFk=
=onFr
-----END PGP SIGNATURE-----

--=-x1yHUTuwiHyssX5JlKTx--

