Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51766 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbZHHIqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 04:46:30 -0400
Subject: Re: [PATCH 3/8] mac80211: Simulate transmission losses on plinks
 to aid in testing mesh metrics.
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Javier Cardona <javier@cozybit.com>,
	linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>, linville@tuxdriver.com,
	devel@lists.open80211s.org
In-Reply-To: <87d476n2vu.fsf@litku.valot.fi>
References: <1249702711-32737-1-git-send-email-javier@cozybit.com>
	 <1249702711-32737-2-git-send-email-javier@cozybit.com>
	 <1249702711-32737-3-git-send-email-javier@cozybit.com>
	 <1249702711-32737-4-git-send-email-javier@cozybit.com>
	 <87d476n2vu.fsf@litku.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pdjEgchq5SAbOW7Ltr9S"
Date: Sat, 08 Aug 2009 10:46:27 +0200
Message-Id: <1249721187.31670.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pdjEgchq5SAbOW7Ltr9S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-08-08 at 11:09 +0300, Kalle Valo wrote:
> Javier Cardona <javier@cozybit.com> writes:
>=20
> > This enables us to specify a simulated loss probability per mesh peer l=
ink.
> > Useful to simulate and test different mesh topologies and test differen=
t mesh
> > metrics.
> >
> > The simulated loss rate setting can be configured as a plink action.  T=
he
> > intended use is:
> >
> > iw dev mesh station set <MAC> plink_action loss 25
>=20
> I really would not like to see debug functionality in nl80211 just to
> simplify the maintenance. Debugging belongs to debugfs or somewhere
> else.

I agree, and I also don't think it belongs into mac80211. I think this
is a good case for actually finally writing the userspace frame
forwarding for hwsim, so you can simulate _anything_ with simple
userspace programs.

johannes

--=-pdjEgchq5SAbOW7Ltr9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKfTtgAAoJEODzc/N7+QmaVDQQAKf4aNAIxwbpJx4cktZotjME
mebfk04C4idz/uOfqw8Ufj7d35Apx0YN35eQnoi2jSrUZf3QjJEoWFXpUoGpPdxk
+GTYyZnKDjt7ylz/kfcgu9pOXeZZWyaNyY8UkVR7KVkDvtb5E5LQFHjYiTBYdVvZ
DOCq3pQBRf7OoLJUOdueVO8naeG1yXsq8nQCrnNz0sIr8I3nvk6QB4gCgqxtFraG
bKE4apRAI6DBkUpPuvAAzfPzeV8/3LMf+CsFK3iMoAdWUytiEMdgqTSZSFOABWWv
+uSykVx4RUpCa12cnn9PXn00oFRDiAhHxSWx+/V1WgFpDRX7bZkFmS/dsc+qiTDP
pZ9HnmgUVHsDgcZioZJNnM414eU+ZyaqJGAyLqsMe/gNKBt3TZvmYXwMJK34xYQs
xsfakT8iyNIq7B9wY6UJWrP0bl771wrIZMjTNs9nYSfXgvtcnwl5ejm1vdXFL6xr
W6a9SEz/JWj5SOdLRW3Ljs8kDS8FXDwgvB2temdW3skK/afYCz1W7iihzawARd/q
70IJFvYVTynvrKieFpChO+aXAtREUHaCfTVhJeuvD2GzVMzzjZiB35wX07tDkxgd
YxosyS4U1nGR7FUPUYA/hPO597ncnJOmU+fbtipRwZ69WuS6XvezcS6QtJ52SnSV
npjKvGjZFDIAlp+fk4Wi
=NQm2
-----END PGP SIGNATURE-----

--=-pdjEgchq5SAbOW7Ltr9S--

