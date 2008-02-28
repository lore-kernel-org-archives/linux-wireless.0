Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42397 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbYB1PAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 10:00:43 -0500
Subject: Re: newbie help required
From: Johannes Berg <johannes@sipsolutions.net>
To: Bharat Bhushan <bharat.b.bhushan@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <d9360e520802280127l32f7f27ch401cf510cd5fd86c@mail.gmail.com> (sfid-20080228_092717_649155_CF81C8E4)
References: <d9360e520802280127l32f7f27ch401cf510cd5fd86c@mail.gmail.com>
	 (sfid-20080228_092717_649155_CF81C8E4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zbnC0hD08NlShUgxOzLS"
Date: Thu, 28 Feb 2008 16:00:23 +0100
Message-Id: <1204210823.6309.56.camel@johannes.berg> (sfid-20080228_150054_336309_00C28BC1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zbnC0hD08NlShUgxOzLS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-02-28 at 14:57 +0530, Bharat Bhushan wrote:
> Hi all,
> i have been assigned the task of porting our existing 802.11 MAC
> stack to linux standard wireless stack(mac80211), i have prior
> experience of 802.11 but dont have any know how of code flow of
> mac80211 , can any one direct me to any useful link.

You can look at http://johannes.sipsolutions.net/files/mac80211/, it's a
bit outdated but some of it still applies. Also, you should look at the
files include/net/mac80211.h and include/net/wireless.h and maybe a
simple driver like adm8211.

johannes

--=-zbnC0hD08NlShUgxOzLS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8bMhqVg1VMiehFYAQISVA//YLCsYjZSZOeEQSyo7ibUEHH+S9MvOH5y
Z6tPfCavmKwibI46oAGNlv8skBeqeqwgK8800OjwGdJUpbdn75JyjSlAjVgV6kCC
olniwVwOtvyRcqjqMLVGJvP3McgZjuPuEaZ6XgMj6qTpDM7jK6pij7B4Z1j29ssV
H15DoVDKoQjD4f6xSBC+0dmntgrUqXe7dBVNTW4DegRe1plY1Yz02CtF6kQLvC/g
yKD8F5n5bxmTF6E6RPhQaCCzAlAG95PkQA3Xpad6Bb+GoX+dYEK+dri7Fso6lsCH
zCP5Nv5qHxw07ojuXqB7VsqzVkZ8+9LNA4mE6mEbXfs+B4Lf9W4GgbGg0jifd/5x
+iu1fAQ454fI12V5sXbe9dK18OwIKghLd+wNcz6FOsZGWeh2jKPJnkk/EcY9lCA7
HZg7wf4e9hAZphW/DzezLjmiEVWufBz0I/5vZgwF+81wQqW4bhZ8gOzikp6ju+Yl
yESqfTeY9sIGo6o/LNV/T73msY+dpZilWWG7EQSAgzzrMTc+oXt14fqsbM+EO9YE
L6fmjvD9N7xU7ROPS4UDXUCgNP9yM3THjNed6j+qIQvMuJodjW4qon7JODlYQvbX
SnFcBWTe5qrrB6CxCSF8qzbMStlNgVwZtnptjU6b8RNKRc3hRiXrhI50bNC5Kjyz
gJz1E+9jGB8=
=jheH
-----END PGP SIGNATURE-----

--=-zbnC0hD08NlShUgxOzLS--

