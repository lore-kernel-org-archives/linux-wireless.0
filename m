Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44759 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbXKNMyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 07:54:53 -0500
Subject: Re: [PATCH 4/4] o80211s: (zd1211rw-mac80211) support for mesh
	interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1194974513.6057.17.camel@localhost> (sfid-20071113_172230_107842_7950721E)
References: <473516f2.15528c0a.7196.3372@mx.google.com>
	 (sfid-20071110_022703_924708_89D9D43C)  <1194689934.7258.66.camel@johannes.berg>
	 <1194911599.6980.107.camel@localhost>
	 (sfid-20071112_235326_369001_A52ADA69)  <1194959673.9116.46.camel@johannes.berg>
	 <1194974513.6057.17.camel@localhost> (sfid-20071113_172230_107842_7950721E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Bn40wOO+1NlxjYJHGGQ/"
Date: Wed, 14 Nov 2007 13:49:05 +0100
Message-Id: <1195044545.4091.10.camel@johannes.berg> (sfid-20071114_125457_704934_4A93146D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Bn40wOO+1NlxjYJHGGQ/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > > Does that mean you're hardcoding the beacon interval here while bef=
ore
> > > > you confused me how we should handle that setting in userspace? :)
> > >=20
> > > I am not sure what are you referring to... anyway, by now I think it'=
s
> > > fine to hard code the beacon interval, but in mac80211 instead of the
> > > driver adding a beacon_int field to ieee80211_if_conf.
> >=20
> > Well that | 100 looks like it'd be a beacon interval in the lower N bit=
s
> > of the value that's set there.
>=20
> Yes, it is, and I agree it should be moved up to mac80211. What I meant
> is that I do not remember saying anything about how to handle that
> setting in user space (and thus I don't know when I confused you).

Ah, from userspace, yeah, that's a whole different issue.

johannes

--=-Bn40wOO+1NlxjYJHGGQ/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzruwKVg1VMiehFYAQIgjg//SpV5h5g2dOq1gCbyZSNe61OQ6L5pGXzY
/7va/OJZYaLKHAwnT7jsN/RcpwKrCVVS+H2vsqeyGO9CheSze7lP5iVu74NIb8Wb
vZlNouJCvXxmPUfUzYQkvs1ggv1s0z8tIhUTVaRIGY/9W0tycUFD9iPKz6Lnovk6
YqJPnfKj6sfUT8CetUkxL12KZwNV9j9PS7pt5jE/arcsGbWJQfOIJBNOisudiIfS
F0yFK5/6NiRPnNMkAgUeZS6BvT3xLpTAnpZPdQH2zkQ9IkEgugjrwrebX/nG1Fzg
LXTtXqeKUsBD7IKdrALNQ2g0c3uezee9L/gTAFy9oNEpaSDtH3GbRTQ4asu//hPh
/D+Zx12VH3uvFeqqewc2qxF72T6gu6IfGc8R8W4fGX/wAem8HY3wcHUzGLLDJjNJ
rTALgvicVTIwQd1yYO58NsNGYes+iSsGawxORU2A09kJQ6mBEbfdmt4iZwsf54St
+PU3lRAt1luO9oCapImeb7frO1lyNGVMQBD7fhMGvaQCzJxUUsj78L9QE2cgq885
UHVFbeOxJMK0xMiAAaELi6ixMyBug4RZ5rThLEDDFysMudX9ouz8eW9gXLA0gN4x
mlDdGlyShTZb1MFcmokgoR3feIElpebB3eY+EzywGVxHAFp4QXenj1DSwjiI+2vl
NqGmJLZVgQc=
=DS0P
-----END PGP SIGNATURE-----

--=-Bn40wOO+1NlxjYJHGGQ/--

