Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48047 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdJPK1r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 06:27:47 -0400
Date: Mon, 16 Oct 2017 12:27:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com
Subject: Re: rc2-next-20170929: wireless down, won't come up
Message-ID: <20171016102745.GA22525@amd> (sfid-20171016_122837_784860_22D05528)
References: <20171016091830.GA21812@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
In-Reply-To: <20171016091830.GA21812@amd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> In -next... after few days of usage with suspend and resume cycles,
> wifi failed on thinkpad x60. I have not seen this in years...
>=20
> [28140.944044] CE: hpet increased min_delta_ns to 20115 nsec
> [28174.048418] iwl3945 0000:03:00.0: Error sending C_RATE_SCALE: time
> out after 500ms.
> [28174.048430] iwl3945 0000:03:00.0: Error setting HW rate table:
> FFFFFF92
> [28174.186576] iwl3945 0000:03:00.0: Error: Response NULL in
> 'C_ADD_STA'
> [28174.186593] iwl3945 0000:03:00.0: Adding station 00:00:00:00:00:01
> failed.
> [28174.206312] iwl3945 0000:03:00.0: Error: Response NULL in
> 'C_ADD_STA'
> [28174.206326] iwl3945 0000:03:00.0: Adding station ff:ff:ff:ff:ff:ff
> failed.
> [30306.599241] wlan0: deauthenticating from 00:00:00:00:00:01 by local
> choice (Reason: 3=3DDEAUTH_LEAVING)
> [30306.624302] iwl3945 0000:03:00.0: Error removing station
> 00:00:00:00:00:01
> [30309.055257] wlan0: authenticate with 00:00:00:00:00:01
> [30309.055631] wlan0: send auth to 00:00:00:00:00:01 (try 1/3)
> [30309.256142] wlan0: send auth to 00:00:00:00:00:01 (try 2/3)
> [30309.460114] wlan0: send auth to 00:00:00:00:00:01 (try 3/3)
> [30309.664117] wlan0: authentication with 00:00:00:00:00:01 timed out
>=20
> (Yes, my AP has funny hw address; but its other hw address fails, too).
>=20
> Any ideas?

Suspend+resume fixed the problem.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnkiaEACgkQMOfwapXb+vIsGgCgtBBOnxTSyMiJxMKMZnyW3UoP
c6UAoLgUXnJ7nm+wdEwFhco69yCfgXQu
=+qwD
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
