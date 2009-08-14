Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbZHNVGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 17:06:37 -0400
Subject: Re: [PATCH v4 32/34] wireless: make mac80211 select cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net
In-Reply-To: <1250281559-13041-33-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
	 <1250281559-13041-33-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zPX4aGb+lqyAxA/DJXo4"
Date: Fri, 14 Aug 2009 23:06:33 +0200
Message-Id: <1250283993.4411.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zPX4aGb+lqyAxA/DJXo4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-14 at 16:25 -0400, Luis R. Rodriguez wrote:
> We can now remove that comment about mac80211 requiring
> cfg80211 and do that for the user.

"now"? What changed to make this possible?

NAK this change, because with it, it's possible to select
mac80211 =3D Y
-> cfg80211 =3D Y
while rfkill =3D M

which will break the kernel build.

johannes

--=-zPX4aGb+lqyAxA/DJXo4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKhdHVAAoJEODzc/N7+QmacW0P/0SsXVnWJE5VB6wbMg3CQga1
btrxCjej2jGSLc+7LCgeTvsOJgti4OeYd8XnGTybWgabwoqN8UXtvkoyYL56qIw7
JJHHjtU1zzdepfX8VGcBG+gSAMn1gypEBP2QRpAdxvnASw6YZA6oSMODvVR2F9I3
bk4EiAV63EWlgnx7MUc/AI6qV7cDuANWZ7iCYWLbemjWrn1WMI3l5336h00ZeUtV
/pMHhBDwB1unj7S5U7G/LPH1meE+3r5K0vkuP5qYqtrWW1B7h8e9gIVEj+4bn72N
NjOo+p0wrCI9sUfGQ3xIoGEg/JcPCWxiQd+X5E61sYCw1ZlsLHJROGb6qqRkYtlR
iunkw5O3WgxRtWbamJqQlDWURuXsVUkBiZF8PLVC3owdNuaWvclNA8WGTb3JyxCx
cOqOOBv0rQ0P3thiya3X6ePAOhOZo7WbwFP/h277G0ZMjaR6WGjTulN/ktaQftlS
Ndikx0ndlo4YiK5ezEM9+vUwq863e+zjUw9tQwEkS6n0M3ScuC6HH91HBCQfXHZY
VCsXEns1HPEGVenx5+zG5BTG1jSuCOb096ZAauxAUpx606cVJCWOuc20N4iCefAX
eShQtDoUrx3PQ+sf0384p8jdX0X5pMgjsEIaFCMMo/Kix+fF85l03ejK8hRI/2vE
T4NcLrHdyoUAwR+w9bAT
=AKMu
-----END PGP SIGNATURE-----

--=-zPX4aGb+lqyAxA/DJXo4--

