Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbXJZKg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 06:36:59 -0400
Subject: Re: [patch 5/9] mac80211: add beacon configuration via cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890710250859t278155a9v4349d9fc8f85bc98@mail.gmail.com> (sfid-20071025_170007_367868_C6C72358)
References: <20071025093618.440937000@sipsolutions.net>
	 <20071025093716.172679000@sipsolutions.net>
	 <43e72e890710250859t278155a9v4349d9fc8f85bc98@mail.gmail.com>
	 (sfid-20071025_170007_367868_C6C72358)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U78cevjyGJOi8sVv7EGp"
Date: Fri, 26 Oct 2007 12:37:18 +0200
Message-Id: <1193395038.4406.43.camel@johannes.berg> (sfid-20071026_113704_513609_8617B951)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-U78cevjyGJOi8sVv7EGp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> > +static int ieee80211_set_beacon(struct wiphy *wiphy, struct net_device=
 *dev,
> > +                               struct beacon_parameters *beacon)
>=20
> To be consistent how about s/beacon/params here for beacon_parameters.

Heh, I guess I can do that.

johannes

--=-U78cevjyGJOi8sVv7EGp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyHDXaVg1VMiehFYAQK60Q/+JkwjQUYv2KY1IdiFZ+4DPNKmDS+60h8Y
d32bUlXqUKmkmFQaPS8HGwizZU6dI5EzGGwEFkBcNuwfa37Cccx0qPMcnRA5B7MH
yoVOyjRRMhnC/TNEhsmoPBsCuw8gVRH4vWRB1T0vpdvT57JRWIA3iuCyXpACFPcb
eEFXN4WniBkmnglbDvWY6JGzjzbSuAmwInnMqUTwIG1Wrzth/31XfvZzr69UJxDO
jdyLEGAAnuGLTDdTuz9xnul0crKZA2ozz8/jT5aBcQ1elHjwP7xzas0ZRwTWEMzK
L+9sXP8rdrbTn8td7JX8B7oKUithm2+YXj7SNWehF8RKDL9D3zB5ng2yJJwHs8q7
zxVCsD0Dr9rUCoBUaFb1Sh7VevuW8XwznltpXXpoc62N13Q057jiCpJMiuz2ISan
x1SZHcDJgdzzQuazXd/e6RiQc2kQnVoZOShIokm5VHbNIqcO8K3IrhvBNiJpUs4y
eTqlz+6MdG/ka5Otk6htq7JFWh79grSKfZhUvPKELQsp/e1wsjWtdjfQhb67Iff3
MfTXlwxcyKlA2+XE6mwpyuIwcf/phJZOhRQhnNl3FaM8PbofcRpcedaT+yb6qMog
/81RRf3QH6SDdsNEpMscqxTTHk0MRY7ZU/SWV1+t0B99aOyqjrnnKicb4ITLKZUD
DUrZRdTZxuQ=
=uH+H
-----END PGP SIGNATURE-----

--=-U78cevjyGJOi8sVv7EGp--

