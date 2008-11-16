Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbYKPSFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 13:05:31 -0500
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan McGee <dpmcgee@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
In-Reply-To: <449c10960811161001h547a7ab0l937bba6bec9d46aa@mail.gmail.com> (sfid-20081116_190133_333904_AC2D115D)
References: <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
	 <449c10960811151838m3fcae118n65139be735c10665@mail.gmail.com>
	 <43e72e890811152148q5f65aa43u49555a3977c205ff@mail.gmail.com>
	 <20081116055312.GA14126@hash.localnet>
	 <43e72e890811152205k13318ab7yad8695d9f6dd409c@mail.gmail.com>
	 <43e72e890811152206s3683ecabm658fac255112a262@mail.gmail.com>
	 <43e72e890811152215h5cf389a3ufe4dc10b021b0c0f@mail.gmail.com>
	 <20081116162019.GA15851@hash.localnet>
	 <449c10960811160838h70fd1852g66d8a51c7551530b@mail.gmail.com>
	 <20081116165213.GC14126@hash.localnet>
	 <449c10960811161001h547a7ab0l937bba6bec9d46aa@mail.gmail.com>
	 (sfid-20081116_190133_333904_AC2D115D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ISqDni9DjeeTxqei5aU5"
Date: Sun, 16 Nov 2008 19:05:23 +0100
Message-Id: <1226858723.3599.2.camel@johannes.berg> (sfid-20081116_190552_761342_3D5A095C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ISqDni9DjeeTxqei5aU5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-11-16 at 12:01 -0600, Dan McGee wrote:

> I had not seen this cfg80211 stuff before when modprobing. I also see
> that cfg80211 is now loaded as a module- was the fact that it was
> built into the kernel before causing all these problems? That would be
> my strong suspicion, in which case this entire thread is really a bum
> bug report, except that compat-wireless should enforce that cfg80211
> is a module just like it currently enforces that for mac80211, saving
> someone else this headache.

Let me guess, symbol versioning was off?

johannes

--=-ISqDni9DjeeTxqei5aU5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJIGDfAAoJEKVg1VMiehFYaP0P/23/2L5QKhCDAPtlA0+bEMVb
vL1hBPvFIBPzTNVdM7IdUxOoFmzU/EgTuj8EzOZJpiUYzwOTMNQ8r8rd24p5EdLg
ayXNiF3+sK43adhZc9k8ILWvCP+nynzUVqHxaEPzJD86LsCk2tIISQZ/PGdI2zeN
PKtcoE7X4x5CTj4NttVToM8cv78820SN2SuWVkvk3tfy1hUA/JYrEXHHdtkLsubG
Hfu5u2qH5NH4KBFsZY9M948OF1JFRuM3kqWuiPP4VUWTDeOEybGcTBGrSCvEw9wx
XfNioz/BMOw5AiFe5I/SBp3ij3s7yQ49utwL87ssNWzfQkQE/ZHX8gkRJpV67c4o
pJMayOdC6Ffu0BHv7dq4I7MYEG4jjXiLgxGPVj3JpDguh+b8t71cry71+RqBH/vG
G1T7QGAIJn8JWagz5iza8bAqzT2+pTeOgDCSEINbjV1JvXghiCzuT/unCihkQGMd
anf9CbotITjqoGRgWap9GvmbIT4vl60JKQsa/1Mmm20/t2QK/My1t5vlY0wKWfC5
4GsHfEq3jAM/ay1XMtYykh6F10iO5e16JQ7ieC1spHYNCqS/KlveA+IU8OHxhXy7
W3P4a67C1D7CddXpS3H0M+FnqjG51g0IM0bZPjwdPunMGpg3mdGr1cY3FseSDfHx
l1SzIZykJDV3rUzvfp4w
=78qT
-----END PGP SIGNATURE-----

--=-ISqDni9DjeeTxqei5aU5--

