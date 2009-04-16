Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbZDPBE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 21:04:58 -0400
Subject: Re: [PATCH 2/7] ath5k: Read Spur channels from EEPROM
From: Johannes Berg <johannes@sipsolutions.net>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
In-Reply-To: <40f31dec0904151751u3fd15d93i194d0abbb4657439@mail.gmail.com> (sfid-20090416_025226_608021_1AD90341)
References: <20090416002449.GB4138@makis>
	 <1239841547.25334.19.camel@johannes.local>
	 <40f31dec0904151751u3fd15d93i194d0abbb4657439@mail.gmail.com>
	 (sfid-20090416_025226_608021_1AD90341)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rtC9RZq6wFLXjsoSEau7"
Date: Thu, 16 Apr 2009 03:04:19 +0200
Message-Id: <1239843860.4669.1.camel@johannes.local> (sfid-20090416_030502_337781_1B1ACB56)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rtC9RZq6wFLXjsoSEau7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-16 at 03:51 +0300, Nick Kossifidis wrote:
> 2009/4/16 Johannes Berg <johannes@sipsolutions.net>:
> > On Thu, 2009-04-16 at 03:24 +0300, Nick Kossifidis wrote:
> >> *Read Spur channel information from EEPROM and use default channels fo=
r RF5413 compatible chips that don't have this info on EEPROM.
> >
> > I think you should break the changelog at fewer columns than that.
> >
> > johannes
> >
>=20
> ACK, are 80 cols ok ?

I don't know if there's a standard on that, I tend to use around 60-70,
but 80 seems good too. It's not just the "doesn't fit terminal" argument
anyway, it's much easier to read if it's less.

johannes

--=-rtC9RZq6wFLXjsoSEau7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5oQRAAoJEKVg1VMiehFYSbgQAMHku5hyENr4wnKBnk7Aydxw
C7nUpIlVJ+aBU0o+EuciB8RzUpOP87MAZfS+GMvv6hzMi3t07SDSzom3+ZOCZdyJ
QMmKrw3KeHZ6AWqAM2RaX0a8R/v9jMbJpWwJ3rC4k+kgCoPVAhsFINL7Cwc3C1oZ
AZvw2AQXRbIW0mTQP2ufrYfSSxT3Nyk25NBux1ujNpsDL+R574suDFbvlLqcyCqM
z7XaL8HxHkuJywQ0riy0RH3UtzaQNV6VHnOA/2rQbaWjESatqAS3ncuvjrMinr8z
yEmbrisHqB0XKvpsTfgSZfBbm5nHjSBFnC2Sxl/GwdlFLJS5CtbR0GZow6d8D6u5
R4TJgc3H5OUhPDru92x+zSyzdESnQAcDTUb6CFo3AhIkZdHf71v3s9jYp++9tuT5
1MH0+NFksKALHZpf2bVRRExYEYMR+slBTG6L7lnVgFjjrPRqYY4m4unT85HHYDWE
nfUm8wiKEZiCiXzv212u3zNCCCDsln5WEX/xZJY8wcpnDHUDsUymbreuQewB1X6f
47vOtWtKXhyBflFd0bTqPz5RcptObqU3RZOAfMz5G3gtnq+CnB4aAqQ1ibS5N4Z+
RWZzwp9shRr0qZcz0Sgcc/iWhMGjS0E+R3QZRmUzAtPC33KkW9jGvPs2MPIU7Myh
q22uQBNw7F6RUvglR3r+
=zgdz
-----END PGP SIGNATURE-----

--=-rtC9RZq6wFLXjsoSEau7--

