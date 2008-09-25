Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbYIYIo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 04:44:28 -0400
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid
	implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <200809250834.07781.hs4233@mail.mn-solutions.de> (sfid-20080925_083440_223989_866F07A7)
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
	 <20080924232453.GG9187@tesla> <20080924233234.GE3639@tuxdriver.com>
	 <200809250834.07781.hs4233@mail.mn-solutions.de>
	 (sfid-20080925_083440_223989_866F07A7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-k6tYFjKt4/ShKYNtXNYu"
Date: Thu, 25 Sep 2008 10:43:25 +0200
Message-Id: <1222332205.10563.26.camel@johannes.berg> (sfid-20080925_104431_992738_1AB28F4D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-k6tYFjKt4/ShKYNtXNYu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-25 at 08:34 +0200, Holger Schurig wrote:
> > the libertas, ipw2100, and ipw2200 drivers don't use cfg80211
> > (at least for now).
>=20
> Yeah, Dan once spoke about using cfg80211 for libertas, but at=20
> that time I didn't saw the point.
>=20
> Hmm, I actually don't see the point now :-)

Well, you'll want to take advantage of the regulatory code and the
scanning stuff I'm working on...

johannes

--=-k6tYFjKt4/ShKYNtXNYu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI208pAAoJEKVg1VMiehFY8hoP/A2PlDsBEFNyrSGj6hBWFavB
oYRIlXLL0o6VzI3U5+2ch1jI9aJsoUJODWvFLERt3YVE8CJ9EjwL7TWSYwJHZR+W
jRs11cnvbaMXrQ/mopIswYXd3Dlcc4qqGs0DWQho2VpWZgd8PdsXBV6gDybn03gb
Iif3dwo3rQtGzD2md15QTNhzWAgsBNZUgQrdp7SAwWp0SkV9JUFOdMqzvs6HDQMZ
KEvrPMxk1dSzfDiKpbmk19bPb3JE1vvuUrOqzkLxw9T8En6jzyvX5+5G0a8NJZod
ymZ7k29wNjBGqbSObs1B6wSSHXTWGm5zUjhMAznHdqz1xF25AuaHmEszsm/mPCNg
6N/7Cws7DLQr/9DLy4/oFiPLXkLjq4sXDPJiBVcumt7XvJFKwLBytp3TscAc+++b
VSUSEzhYDX05ESRj7lgf8EX4CrjtiYaK2faqmasr3RFCpiqaRSvGA1l5YmGQXKeE
6eSnfXVkXtOqaX3l1IQHLQ7Gr2OGRIjBdHfHfxk1Z6ft+jDfOSNOWtAxJY7AThLi
876FATN66PG7tH9n1niW1vCF1snvyJFCeNMn7QQbbSNpFwSyZyqIiSjdtn1G45r3
VE2cMRjN6YqBIMe98/tX6YhziPUKaUfP9D0x/Tet05wTn2rWtoO4f84kZu/MVV0h
FRE5y5NpRzHDNlGHwINr
=1XMq
-----END PGP SIGNATURE-----

--=-k6tYFjKt4/ShKYNtXNYu--

