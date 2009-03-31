Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44083 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZCaIDf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 04:03:35 -0400
Subject: Re: [RFC/RFT v2] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <49D153C2.7010706@lwfinger.net>
References: <1238349195.24972.5.camel@johannes.local>
	 (sfid-20090329_195345_745378_2F2074B3) <1238451390.5970.59.camel@johannes.local>
	 <49D153C2.7010706@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0p8JF1Ai5opo44lZr0n0"
Date: Tue, 31 Mar 2009 10:02:57 +0200
Message-Id: <1238486577.5970.70.camel@johannes.local> (sfid-20090331_100348_648902_122ACD64)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0p8JF1Ai5opo44lZr0n0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 18:20 -0500, Larry Finger wrote:

> Initial testing shows at least two problems with b43legacy (and probably =
b43 as
> well):

Thanks for testing!

> (1) On bootup with my radio switch OFF, the driver ignored that switch an=
d
> associated with my AP. Only when the switch was turned on and off again d=
id the
> driver log the expected "switch off" message".

I think that's expected because I'm missing some code to set the default
state when a driver registers.

> (2) The radio LED is on no matter the state of the switch.

That's strange. I'll take a look.

johannes

--=-0p8JF1Ai5opo44lZr0n0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0c4uAAoJEKVg1VMiehFYIjgP+gL5tMrg1pn0H3/AtwKo0Mzg
MQH/5dYfYUA6gIZDDIkrPU1bHvtdYcnQ3QtM2tU+uWtDCG1dHsz1nSYML0s8RbXA
nEdyI9q5EBxKG1BjBcpykZac5wom80V3FqixVDIjj5BDRJVEdJB1RyCtG8sEyDOs
ODL8BYTyAlIN7zfJbpO3YiribvbuFtQYPnFg+D6GbYWZosY18ryvcsQGo/u2UbXa
I2SwlXgHDfRnDKqbaGnyIgVeIxxdpqBWCaBIYzeP94PzPijou7TesO0qUhbV5viH
LsiDA6cSbKHvgwH68uqgaBP2qSn53wIcBKVHyWwE4D6dHvKmhqRxTs3npsdjK5Ln
CpE+mX8zvIr+YeVSyFrUtv1+RIoovbhP7vzChxuej62wWLok+3Hbqw3d8RaY6XDg
SFD4/uqUc7pz4XG44epUp6id4/+rahVKdNymCTbbnDcsXVsRMRsCmaDhT4+dccpU
Izdnq0HtkUAdNmHOFAvCKEihmkpSjPs747vA2O0HYbOWBPmtChV5VivmRyOE6nm7
poYT6X4BAhlnM1rq+OxwNhk9t1SQ107oG+uweEZKVB5IoAnWtqVxeNqstyPp0E8g
wJIqBXJSMLbaS4+JQ40jyLG7ApFyY1dNzePVLsNC3zLYlK7lY8RikJ8OGPxPzxzg
cabpYw12LK+wNed9rTD/
=0Td7
-----END PGP SIGNATURE-----

--=-0p8JF1Ai5opo44lZr0n0--

