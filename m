Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59799 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760133AbYFZN06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 09:26:58 -0400
Subject: Re: [PATCH 3/4 V2] mac80211: add last beacon time in scan list
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Tomas Winkler <tomasw@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1214447333.18897.13.camel@dv>
References: <1214396229-18782-1-git-send-email-tomas.winkler@intel.com>
	 <1214409527.5881.21.camel@dv> <1214410337.21847.33.camel@johannes.berg>
	 <1ba2fa240806251526k773e8e2bj2c198defd0d8ef@mail.gmail.com>
	 <1214447333.18897.13.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-51bwMEUqxpFgUz3FmvO8"
Date: Thu, 26 Jun 2008 15:26:45 +0200
Message-Id: <1214486805.20763.42.camel@johannes.berg> (sfid-20080626_152731_495746_1B88B99E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-51bwMEUqxpFgUz3FmvO8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > Actually, come to think of it, isn't just doing the difference as in =
teh
> > > original patch correct in 32-bit unsigned integers? It'll wrap around=
 a
> > > bit but that's ok, no?
> >=20
> > It would make a very recent beacon to be like half an hour old on
> > wraps, wouldn't it?
>=20
> No.  Why would it?  Can you give an example?  If you are not increasing
> precision, wraparounds should make no difference.

That was my mistake, somehow I thought we'd have to account for wraps,
but that was wrong I think.

Let's use v1.

johannes

--=-51bwMEUqxpFgUz3FmvO8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIY5kRAAoJEKVg1VMiehFY6pMP/14W4Zc4XHzW3ygrAZdz5k34
idgrjU0PUyTh4YtxSIpNs2cS/7gEM7/Tybusk9+Ri5K4EpGG78AqYQCxO58XLtFU
zVOrfzmdyEl1rgAlbqihk92dmWBZv1f595dqIDI97LdUESfqIpJNPBxlt0/72b/C
53W+TdKrujQIb3ms5ip2irYkzFHurF5InuHZKZEHswYSZIU0S12OWZyYGN3vUbsu
cG/FHNn9p51xB0Q4PAe+XYgzCI9n/QbiHXfBu9yBl5l5lOWdjUR1e0BOnzkZkl8v
9lS7luENkjmO/VdnwtmyT0ioaBZjIx9rz08W4E8tm0zUiYTZcEFaWyIRffLwPIfK
r30oCI/CiS5IKb7YId4w+rqcQwHCjL2o/4nKaFm8fQbBxRbphxcjuzaCZYxiE8Ac
Q41YH7iMOXDZAs8oi/sJooUJGQsJowh6ZBmyMio+rxTqoCHoffgAiKVXoo7EFYQj
UhTjDyvR8NBNOTO/IpU5PYweajztt/gDcqetW7P0PX1xh6Zjr3gj5YHyGbShQSlW
k4S8xPgpoy4aCvKR4guNtX3pe/89vo6DlW5vlKuOYJL+yiHAlqbGibf7Svzioz1X
AZjcd4HZJNYDo1TV9JT96fYSCFb/JAg90F6XFeM4ej7fRswUzCICKG6JKWylpoBy
92RkgJpeZQs4mHCQPL83
=W8KC
-----END PGP SIGNATURE-----

--=-51bwMEUqxpFgUz3FmvO8--

