Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35466 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYKTG6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 01:58:17 -0500
Subject: Re: [PATCH] wireless: sysfs was displaying different values for
	level and noise than procfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1227131518.3571.16.camel@dv> (sfid-20081119_225207_085809_144B09A0)
References: <200811151831.26403.arvidjaar@mail.ru>
	 <1227122019.2196.14.camel@dv> <200811192245.29487.arvidjaar@mail.ru>
	 <20081119200856.GH3485@tuxdriver.com>  <1227131518.3571.16.camel@dv>
	 (sfid-20081119_225207_085809_144B09A0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e+3pSXHLKr70TMZAg2/F"
Date: Thu, 20 Nov 2008 07:57:38 +0100
Message-Id: <1227164258.17336.20.camel@johannes.berg> (sfid-20081120_075820_348690_B219DCE0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e+3pSXHLKr70TMZAg2/F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 16:51 -0500, Pavel Roskin wrote:
> On Wed, 2008-11-19 at 15:08 -0500, John W. Linville wrote:
>=20
> > > But positive dBm is not even possible to represnt right now. It is
> > > u8 and is displayed as ((s32)level - 256); so it is *always*
> > > negative.
>=20
> I would force dBm to be between -192 and 63.  That would cover
> everything even remotely possible.
>=20
> > And what is your perspective regarding potential 'userland ABI'
> > issues of either this patch or of Pavel's suggestion?
>=20
> In my opinion, discrepancy between procfs and sysfs is permissible.  If
> the sysfs interface has been wrong, we should be able to change the
> format.  As for the procfs interface, it could be deprecated.

Actually, I was hoping to deprecate the sysfs interface, there are tons
of apps relying on procfs unfortunately and very few, if any, relying on
sysfs.

johannes

--=-e+3pSXHLKr70TMZAg2/F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJQpeAAoJEKVg1VMiehFYYOkP/jlz+smCGK8UnxMzqxiP03Eg
6UjudjZC0FwAWWHXhSxjF8M8lHcZSjsC59WOsOIXPSzXZ35ZdPKz2padq7IN8hX6
3A3cz2Yk7nnlgTaWwhXWOjhBQAaXU+JmOKai4QZRSmt52MV0sWc9o7Ab+2GRiBhi
ZX+0mTWhHQFEumBaCpcCnN0lV7XTmdlO3/rwH6Jbdg6r0Xl8zl0tQMveY4asNNDe
pYLaivUuJHot0mxRdNkAJ/ltXW7MxNsxGO5UUviqlN77avZJg7bsGfbI/iykZFPn
D8mOgDaLjkM1iC+OpdayJLCddujRgoFaYe9GdJnCtR1MIiryRLpgXYMHZugR3x4J
Maz/P5X7sEPXfT3qs12zbUZmtjsrEtIv0FDWQzGWe21c3Uw4o1mKW2PyU/oSuJm9
GZP1ZpAIh05DqF8MgWFtk1e3CjvQPP18PKB+zOsYuZHFYyN2VmoZEt1ibPLySbXC
HxQ9y9TOdAvtC8tRwKpAwfJUcqltOs7p3a45sV7qj/iiX8M/TtgQJlUEfnmifP7q
L/H3QjX3hd7BSmXLymIlX3YlqBa6MPVDVbM7KcC+C5R8EvXpl2n1WlOQL/om7uCZ
dSUv8QRDQdDyhEiituKegA9w8MrpQp0uvTz7cYukXpR6HVV+BL6g5RnJu9iPXpEr
eSo46rPUIJOrwKQse/hE
=H9e1
-----END PGP SIGNATURE-----

--=-e+3pSXHLKr70TMZAg2/F--

