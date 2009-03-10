Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbZCJHQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 03:16:29 -0400
Subject: Re: [PATCH 0/4] wireless: use channel bandwidth
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1236650699-30538-1-git-send-email-lrodriguez@atheros.com>
References: <1236650699-30538-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r4Kfx+NPNQMPeoTmICrs"
Date: Tue, 10 Mar 2009 08:16:23 +0100
Message-Id: <1236669384.9658.32.camel@johannes.local> (sfid-20090310_081630_961934_C610E071)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r4Kfx+NPNQMPeoTmICrs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-09 at 22:04 -0400, Luis R. Rodriguez wrote:
> Few patches which actually make use of the channel bandwidth, lets
> also send this to userspace as it useful to tell which channels you'll
> be able to use HT40 or not on as a client.

Can you remind me why we have that max_bandwidth at all? It seems we
would be able to see whether ht40 fits by checking the above/below
sideband channel for use permission.

johannes

--=-r4Kfx+NPNQMPeoTmICrs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJthPEAAoJEKVg1VMiehFYLEgP/3btmlNCn+jhilwGnVOlgyEW
7HtYGmb7UcXobivMG4tQWadgSoCTouJKrKt1ZfbrQMhtWUisqfE4NErXyvqFjylG
uUgniFFqG3KMx0KnitguMSt3DXvWD1O0T9AV43VeOoKWorST/orRXS9W0eFO8uca
FeMEhZkkbU+naaZaKjk8sYhn4ZKhYeUyVQ+Z7JF8+VPvII1TVb0zeyVxNU5AqSQV
SPWKgnh8gIVAjvtG/kcnt/rWA9gvkP+eG0+rXI/vj1pYMz2ytzVgsc8yP3G+qlMT
LWd2dyYdbJ5IooxKlNmZEh+rRPpH+3zg7HCMfWNB+na3Rehy14TrAy/CAPmW7/ue
dq1D7n9C1F2EKPEu5UQWiRD7j8Sn6AAxmy6Z/zmEFoM4EUCHuqLOPBlTBqeIvHVC
3LtG5XP2zhFZTIVhIEOdxIFxs0fwmn7JB3GiJECe41D/VYC3cxvXvgmL3mOWrADR
m4T6TJaZKJImhtTFdJkG/YDprSO4vpst0QmmTrmXYU+VFz6wTph0LWA7CceOcbir
DWscmsrcjOJqrhfFILyCii5GZsYm6rJYxa5sbCf2pLPNet9mNtK8T/ESDxDbfDWz
zGh8aQ92FrbG/vFJKvRrjP7HNhVXJtuNenTDRcnid4QyGOVALxS7+6INN7MNcDXF
PeR0GI+MnR9vfgGXzHXD
=qqEp
-----END PGP SIGNATURE-----

--=-r4Kfx+NPNQMPeoTmICrs--

