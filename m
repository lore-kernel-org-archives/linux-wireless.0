Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49925 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701AbYEMIrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 04:47:12 -0400
Subject: Re: 11n + wpa_supplicant
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Jouni Malinen <j@w1.fi>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <8704f27d0805130141s403167b8q49eecb645d0461c1@mail.gmail.com> (sfid-20080513_104117_720017_5571EE8C)
References: <8704f27d0805130118p6f597743sebed5a2cdb6d59cb@mail.gmail.com>
	 <1210667328.3646.24.camel@johannes.berg>
	 <8704f27d0805130141s403167b8q49eecb645d0461c1@mail.gmail.com>
	 (sfid-20080513_104117_720017_5571EE8C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JX1YaUXdoy8LDa0GoVp8"
Date: Tue, 13 May 2008 10:47:01 +0200
Message-Id: <1210668421.3646.43.camel@johannes.berg> (sfid-20080513_104715_685444_137686D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JX1YaUXdoy8LDa0GoVp8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-05-13 at 11:41 +0300, Emmanuel Grumbach wrote:
> >
> >  I would think that, indeed, it *is* its job since its job is
> >  key/algorithm selection and 11n limits the choices.
> >
>=20
> depends on priorities, maybe the security selection should limit the
> 11n... IMHO, security should be in higher priority since the user
> explicitly said he wants TKIP
>=20
> >  How about we simply put the 11n information element into the generic I=
E
> >  and have mac80211 use that?
> >
>=20
> in mac80211 we perfectly know what the AP supports (in
> ieee80211_send_assoc, I can read the IEs from the AP) , that's no the
> issue here, the issue is what security alg the user will chose in the
> 4way. This decision affects the associate even though it occurs after
> the association

Ah, so you mean if the user chose TKIP then we should associate as a
legacy STA?

johannes

--=-JX1YaUXdoy8LDa0GoVp8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASClVhKVg1VMiehFYAQJVeA/9G9LCSblMO/Z1z9xho9R31JkHtEhNpdyr
6DMRq+5G+OJqFn4Fr5ZMn4oSzE1wctnu5MLuRyoJ63v7IbmqiPmi3OGQYycDinKw
b5oxz19M27hicjG5ojlD6b0VghR/r7WwJxGEU6OldsxZPFR4INIom9sq0S29kKrC
dGW7q7cfEhjyLaY4WkJR1ENVKzO5z+IonOcK5N1MMbGKO4sr+3iyTRyHQvc9hqvM
EP0lhx0c0hD5xDTQnDTggLveYoM/N5XQU7H42jk5Q9LSq8JjblCAapoYiybk4QAM
+rAx1r1uC8F3x1YYFfwhmkOiON82Rnlhhrurav999wjPm0Gi43R+KCr3QfdUl1Pa
idUerr6BH/pwYnfzz+2+ZLLvJDF2ecV6y5oC4DIdROz1MoBV5HEj2NsbMRVb9+OF
rsLeU05LDaF9A94VTrk20dm95GxDQMc6S0l7J/8/lbpdUi9kkaFmpgmgN6n+Z5DB
4kuNScxAvjX8R/JKrPusK9k4b2LIQFkSuNaSLy+03Dy+xHMMMy1HwF7A3J+UvChF
cwhpy/pwKEMmmyErSAXueAXfuXNQIVGNXdxRrH/dqCAM8poii4stgBHX4mz2k2TJ
hoGFEiOl745U4AcGuPB2lCXh1/45OTdg63k9XLwxjX5/DrWXssszMSNYBrXvLICd
gX6a6KfKOjw=
=WiPM
-----END PGP SIGNATURE-----

--=-JX1YaUXdoy8LDa0GoVp8--

