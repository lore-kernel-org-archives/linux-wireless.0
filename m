Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46143 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751501AbdJPJSd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 05:18:33 -0400
Date: Mon, 16 Oct 2017 11:18:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com
Subject: rc2-next-20170929: wireless down, won't come up
Message-ID: <20171016091830.GA21812@amd> (sfid-20171016_111848_361349_2FE53CD8)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

In -next... after few days of usage with suspend and resume cycles,
wifi failed on thinkpad x60. I have not seen this in years...

[28140.944044] CE: hpet increased min_delta_ns to 20115 nsec
[28174.048418] iwl3945 0000:03:00.0: Error sending C_RATE_SCALE: time
out after 500ms.
[28174.048430] iwl3945 0000:03:00.0: Error setting HW rate table:
FFFFFF92
[28174.186576] iwl3945 0000:03:00.0: Error: Response NULL in
'C_ADD_STA'
[28174.186593] iwl3945 0000:03:00.0: Adding station 00:00:00:00:00:01
failed.
[28174.206312] iwl3945 0000:03:00.0: Error: Response NULL in
'C_ADD_STA'
[28174.206326] iwl3945 0000:03:00.0: Adding station ff:ff:ff:ff:ff:ff
failed.
[30306.599241] wlan0: deauthenticating from 00:00:00:00:00:01 by local
choice (Reason: 3=3DDEAUTH_LEAVING)
[30306.624302] iwl3945 0000:03:00.0: Error removing station
00:00:00:00:00:01
[30309.055257] wlan0: authenticate with 00:00:00:00:00:01
[30309.055631] wlan0: send auth to 00:00:00:00:00:01 (try 1/3)
[30309.256142] wlan0: send auth to 00:00:00:00:00:01 (try 2/3)
[30309.460114] wlan0: send auth to 00:00:00:00:00:01 (try 3/3)
[30309.664117] wlan0: authentication with 00:00:00:00:00:01 timed out

(Yes, my AP has funny hw address; but its other hw address fails, too).

Any ideas?
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnkeWYACgkQMOfwapXb+vIklACfdQ43Ty+CIfJAVr1HIFfdmieF
T/IAnRlgThadb6YjkYZysa5O48KdvVa8
=+8MF
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
