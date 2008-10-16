Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYJRMUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2008 08:20:18 -0400
Subject: Re: [PATCH] p54: change firmware names for usb devices
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>
In-Reply-To: <200810161330.38726.chunkeey@web.de>
References: <200810161330.38726.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Kr04axvU0W7GygUy6QRa"
Date: Thu, 16 Oct 2008 20:06:57 +0200
Message-Id: <1224180417.735.88.camel@johannes.berg> (sfid-20081018_142026_233198_40C160E5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Kr04axvU0W7GygUy6QRa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-16 at 13:30 +0200, Christian Lamparter wrote:

> +/* outdated firmware names */
> +MODULE_FIRMWARE("isl3890usb");
> +MODULE_FIRMWARE("isl3887usb_bare");

I think you should probably leave those out.

johannes

--=-Kr04axvU0W7GygUy6QRa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI94K9AAoJEKVg1VMiehFYRjYP/R28La2aB9Qngl27crDmQTAK
MTUbQTT8N7QAHkKtGUWAIFLpOB9eHI3eDQxmmu/71hIk9f2Hi0f0J4XgxKPYLmj8
s14Xb94spUwhZeLo2RCSUo0ewjn/h/ixI1LiSqkQtrAwFVcA9ee8iIvmkEpX2nOd
Cs69c6EiA3hj1jQM21bUh2rIRFdWa/IEEC3N83J6BtqWM5eckMxmfx2o97mBpACe
795VRM/Kk40/T4ya7PZAp6busjFMNcZUgIgcA4lMO4bKG8z1S733bfoB9pQpetyu
HZviqmKIqmF79g8+x1bTSi3scTlr61s2kcbRZ1y9YOfvGouvGEC0h7IXnFLDJoCx
ds5jKgk9AN/9rPZ0GqFX2tsGn53L5GtVxoY2lT72Dbcz4Xb3yLWho42Fz0TzEtf6
iWuUzybjZv7c/yyQsrt/1uwQHQ3TIXCFJz6lIgw14JbpKhDbXK11ZNkz9rCvQ5/r
DY6XYecmFjClfUcV/lrDJ/003zl8kMZ4GGPuc+qKT0xdIIbcTdfJ8+p34NzwVsDE
CNdixlhve6ZD6zBea3tTzf7RSa/Jqfqy5ECxXcWOl5LQK5UQGRtIMgR8b2RlSZWk
VlyXl425h44vwZvIrOm1cG42kl11Y/q+Pzev4eGYSUIKbUkP+oiMmeCbIZbZfD+s
hLeLf/COWT93afKSrqcl
=cjoP
-----END PGP SIGNATURE-----

--=-Kr04axvU0W7GygUy6QRa--

