Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48721 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbaDMNzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:55:00 -0400
Received: by mail-wg0-f49.google.com with SMTP id a1so7123111wgh.8
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 06:54:59 -0700 (PDT)
Message-ID: <534A96DB.90505@gmail.com> (sfid-20140413_155511_515099_1B0D49F4)
Date: Sun, 13 Apr 2014 16:53:31 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2014-04-13
References: <534A8A49.2030100@gmail.com>
In-Reply-To: <534A8A49.2030100@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gHGiqUej4jieXwFX7XDOFx2beKARnv9Am"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gHGiqUej4jieXwFX7XDOFx2beKARnv9Am
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable



On 04/13/2014 03:59 PM, Emmanuel Grumbach wrote:
> Hi John,
>=20
> This is a first pull request of fixes for 3.15.
>=20
> I have new device IDs and a new firmware API. These are the trivial one=
s. The less trivial ones are Johannes's fix that delays the enablement of=
 an interrupt coalescing hardware until after association - this fixes a =
few connection problems seen in the field. Eyal has a bunch of rate contr=
ol fixes. I decided to add these for 3.15 because they fix some disconnec=
tion and packet loss scenarios which were reported by the field. I also h=
ave a fix for a memory leak that happens only with a very new NIC.
>=20
> I'll be with low connectivity for the coming week and a half, so I want=
 hope you won't have any issues with this pull request. If you do have is=
sues, please let me know, but I am not sure I'll be able to handle the pr=
oblems immediately.
>=20
> Thanks!
> a6bc92803e7f765e02c923cf37c8e280e729642aa6bc92803e7f765e02c923cf37c8e28=
0e729642aa6bc92803e7f765e02c923cf37c8e280e729642a
> The following changes since commit 67b3bd4e65f0854aca70e0134d59b1daede4=
9504:
>=20
>   brcmfmac: fallback to mimo_bw_cap for older firmwares (2014-03-20 11:=
55:41 -0400)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.g=
it for-john
>=20
> for you to fetch changes up to f59913dfbb8ce07d7fb527f67b26791aa849aa1c=
:
>=20

I had a typo in the stable address in one of the patches - new HEAD: a6bc=
92803e7f765e02c923cf37c8e280e729642a


--gHGiqUej4jieXwFX7XDOFx2beKARnv9Am
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTSpckAAoJEC0Llv5uNjIBlGIQAKBJkEyR1afubFd3TnMsf3qH
B1d186cvmw57n54qKL6Kd0iSb61193nOGqkeT+fkvD0lGZ2xORDdD2y/VnK+mEo/
lVhzK+ma5Q0O1xVNTPsl6lGtOwADjgx8mmOkuGpJseyu5ZPu2or17khGDwUbEIxM
ukuK5Z7rH5y8U8DAwf7QOXGpOqGTvknSz3fez1BfmE16gAdYsxbkSAzmE8PjTTxE
VvZkv5CDyRIkpdpiJSEzOa0S1DglYvs/5L4TeReKAfbnwJOP/jGffGkWEEDTSGWg
mAyJY2PKx8NWWQN15Eo+LvUyNJj2kFPDga3QnFuDmczEZiZg14YBZ3SCq1o9mYhR
JpCYzoXxFVEoE4eGllwvlFDGrxQsosZJiQgunUUDsm9nuclDxZtt+QPc89j85KUG
ZxFPXqN6/RdSB6G+BrNO38eidHWpHBJs1eHGsLxIcx+PwS21H0hSMTnzwV5GPA7W
h4HdqKtuATslOPHcAnupBbqaDiNo74IFdDvw3unzlPUn/c4L8jQKv7jZo2thvDrE
NSUr/nqyl03NPQO9PSc6mRJGFXMS46PN+78gw0hl7LQd4WrPpBpHP4H9ecIqAZwx
aGxWRQ/PAqNLLaFq4x8n/OTZwVMwkpiWG6/ebs0LzdV+1SXU8DrCsgMf+Yfwi/SX
PyINBDiVdbCmdbNATy2b
=gasd
-----END PGP SIGNATURE-----

--gHGiqUej4jieXwFX7XDOFx2beKARnv9Am--
