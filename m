Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45006 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbYGAW5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 18:57:19 -0400
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
In-Reply-To: <20080701225207.GB4292@khazad-dum.debian.net>
References: <20080701225207.GB4292@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O7yd0BvOfXjaX77yYQgo"
Date: Wed, 02 Jul 2008 00:56:33 +0200
Message-Id: <1214952993.3462.14.camel@johannes.berg> (sfid-20080702_005722_516953_D2574020)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O7yd0BvOfXjaX77yYQgo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-01 at 19:52 -0300, Henrique de Moraes Holschuh wrote:
> Dmitry (input layer maintainer) added to CC.  This is a [gross misuse of
> the] input layer issue.

FWIW, to me half of that mail reads like a rant and I'm ignoring it. If
you know so much better, why don't you continue working on fixing it?

To address one point though: userspace does want a notification when the
hw-rfkill is activated so it (e.g. network manager) can ask people to
un-rfkill their device.

johannes

--=-O7yd0BvOfXjaX77yYQgo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIarYZAAoJEKVg1VMiehFYrkUQALwYXwJXkDlPBFm22y4z3yMe
VM5WUgglbuD8olnqLkZSOICdJtgkWKkHiC3TXLTxvmoH9BOU9/bBJ8eBKynEhTQG
DACVngv3YRlZ4Dvca7MaLB+GU30aqEZIjHbg1Xj3rnOkarSFBzmuOIOUS/dxsVSi
DHfEe60vScvh4zJMlqRdaj6hiP+3+Ho43LZ9KkGJGz297FZHWcSK/kRKrJO1smN3
EVbAX+ZhWL9qDSzTp5Inq1bp+ULCEH5H8m7ivAyE3nEzLMAebYurYq+Q/gbbW7Fy
nN7xuYhQ41oV0Sx1E9YOF7NffNh2dSOuiL4QnYSGMNOHIS0AAf0xtCYDe5n2VTS7
FqPZMrZf/rPMhLQWnNkj7bfVHQ/V7greH6O3hX4FMwv7CGMCey7HAx6qEuotgaZV
d7OKOe8AVpsPsSCeUYL2+aJQWiJjjbGWU2pusFiK9mcThWFVxvZxw4hYoL4ByMDk
YuINZwMJ8M254S/9wjJDcVThiskIUYdwCLHm80RqrOKm3h2E6bxWg7xR9vBlFkef
cPo99fu3CY6GE0diMOUXA3WSl/TG4d+m4wHTY1kMWTdoTC9YwUWAG6v0FGNn9R/N
82kWUAujkf95FHYlqutGHjNlv/SCvq6BmcNKHBUSeHHhtQYD0t19XegVAe0aZAxI
lE+DW4BbWvKibU9LCCME
=GEfv
-----END PGP SIGNATURE-----

--=-O7yd0BvOfXjaX77yYQgo--

