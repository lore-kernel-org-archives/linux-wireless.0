Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58568 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbYGXLec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 07:34:32 -0400
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
	rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890807240105k5626c793if9cb9a2e3f62835b@mail.gmail.com> (sfid-20080724_100527_979344_6084D9DB)
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <200807221613.34434.herton@mandriva.com.br>
	 <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>
	 <200807221940.20009.herton@mandriva.com.br> <4886AA3B.3000406@lwfinger.net>
	 <4886C50E.6040304@lwfinger.net> <1216824917.13587.9.camel@johannes.berg>
	 <48874F09.7060400@lwfinger.net>
	 <3ace41890807232028u576371a6ra944431327cac76c@mail.gmail.com>
	 <488815DE.2000903@lwfinger.net>
	 <3ace41890807240105k5626c793if9cb9a2e3f62835b@mail.gmail.com>
	 (sfid-20080724_100527_979344_6084D9DB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-irNXop6TUVVC9MFL3I0K"
Date: Thu, 24 Jul 2008 13:34:01 +0200
Message-Id: <1216899241.13587.47.camel@johannes.berg> (sfid-20080724_133436_013740_1E2C3EFE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-irNXop6TUVVC9MFL3I0K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-24 at 09:05 +0100, Hin-Tak Leung wrote:
> On Thu, Jul 24, 2008 at 6:40 AM, Larry Finger <Larry.Finger@lwfinger.net>=
 wrote:
> <snipped>
> > I will be submitting the proper patch tomorrow, particularly if it work=
s for
> > others.
>=20
> I was being over-optimistic... it worked for me for a good while but
> doesn't after a reboot/what-not.
> So it probably needs to be done but there may be more missing.
> Do we need to start the seq number from some where?

You shouldn't have to, but if you ever want to support multiple virtual
interfaces you should put it into the vif state instead of the hw state.
Not that it should matter when you have just a single virtual interface.

johannes

--=-irNXop6TUVVC9MFL3I0K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIiGilAAoJEKVg1VMiehFYDcQP/1RFQabVOxXyzjjP4bZJ/6pZ
PTcTymGGwAUpFJy0LeH+jNBqX/s/V03N5Hp9ppTbs5XIF+Hjto6bFXtUQsjBnGzY
kNn+85PrXwnGOJimdgOROshRpEMw8bd/X7/LeYNmLkNJm+B+iV2QrkrIE5EZeS/0
Hte0yu0CnaScFYwXdz9lS4iC+u8LQCgbkUVU/9HM8mOHnvrrMmIcEkBNTuVdQAKO
dgoWZ3KVxWI4DSVA7nJlWnywyoxf8OQizWQf2lPQqWPi6hXaMJxzq9jUEcs6awDG
XkvRxzETUn5VYszO2mlua+VD6MsIzmFUn++NTogfK0Nr/0SExRc+qxVOuWMoUZ3d
bMdWf1O4a0fno8vb/16iDF05pylOqYQylTb3C6cTwL9Y8KHCW4hJeP1czsjt/Npt
xLdPUtc9/eTk5dZRID7vT3PGOXuvKcaVwXpMUHpLIWFCF4x8UZgAQhJavTGEFK+f
YHvc6lEh6cvFyE+NrL6QdjrtO1bTJNfGuU5W9pj0GlwrSGpBseCDK4ktMca+6RvY
WY98XHQKpB5PIUFWvQCBp1DD4n3zRhxfNZuRFGQtd9BusGbK/EjtNYhU67FB4kwN
Nl4cbwnCcNK0F4+/PTiDYOTc01h9d1ZhmyNOh573fD10M1dNCl1Jsf0UhPAOZdo4
7G+hahWM0uvy7z1mx9CH
=6fDa
-----END PGP SIGNATURE-----

--=-irNXop6TUVVC9MFL3I0K--

