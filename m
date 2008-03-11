Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57443 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbYCKUGx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 16:06:53 -0400
Message-ID: <47D6E649.3010309@hauke-m.de> (sfid-20080311_200658_148145_120B8243)
Date: Tue, 11 Mar 2008 21:06:33 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Franz Apeltauer <franz.apeltauer@gmx.at>,
	linux-wireless@vger.kernel.org
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
References: <47CB3B5E.4020701@gmx.at>	 <43e72e890803071859r2788075cp12272cad0920d2b0@mail.gmail.com>	 <47D5AAFC.80401@gmx.at> <200803102321.35909.IvDoorn@gmail.com>	 <20080310233307.GT28995@ruslug.rutgers.edu> <47D5CD59.5050400@gmx.at> <43e72e890803101826m5b7cd55ao9f521a786a36c07@mail.gmail.com>
In-Reply-To: <43e72e890803101826m5b7cd55ao9f521a786a36c07@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB046C7E2E25F33ECE5D1B05B"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB046C7E2E25F33ECE5D1B05B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Luis R. Rodriguez schrieb:
> On Mon, Mar 10, 2008 at 8:07 PM, Franz Apeltauer
<franz.apeltauer@gmx.at> wrote:
>> Luis R. Rodriguez schrieb:
>>
>>> Frankz, I generated a new tarball with this applied. You can either
>>  > patch your local tarball with this patch or just download the
>>  > tarball again.
>>  >
>>  >   Luis
>>  >
>>  > commit d4097ab3593a721fc1d99823d2442464debf7f09
>>  > Author: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
>>  > Date:   Mon Mar 10 19:20:33 2008 -0400
>>
>>  Loaded the new tarball.
>>  It compiles fine.
>
> And it works too I hope? :)
>
>   Luis

On my system the tarball is compiling now, on Sunday it does not so,
with the error mentioned here.

It tries to find the .config for the kernel at /lib/modules/`uname
-r`/.config, but it is only at /lib/modules/`uname -r`/build/.config on
Ubuntu and Fedora systems.

--
Hauke Mehrtens


--------------enigB046C7E2E25F33ECE5D1B05B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIVAwUBR9bmTYZ0px9YPRMyAQJJfA/9H8yspcTUBYyiEVJ/Pz5Ari5MoBj6f5UE
z/FLQm4x+KOkOF32pmsb8C0WLRB9N9zZbb6B+UoZB0LnaaW+vp3e+QFpo+T/iVs7
jnAyeElhvYFiK0nlXIF7fp6qBzx+wHbh+ZGWpdLwslOWcokzzQKE50ClK3+PJ1C7
Q+h536gQC0sgoflwVk3bekSlwrmVWLbp87UtyTUTt8yu6B0UGe47C68zIDv4xRO2
/2Zq6m1e7gBloysrFtNzUG3/gXJqLXrrq7RTEYvr74wc71mcelKnKBky7QcT/D1J
Vc2ktcA4Xt65opmiXeymvKX0Olu/nIhjC5EUph8g7ReaunjJqnkcItai4cWShQPs
Tv/cVzjdi0oiL3ok4/NU2q3ap3x7mPyQnuYg96DVB42ekJGPqLCjUlU5zvfNV8F3
BVT+x32xm08nt302nDmZTK+Y0Lq7VheXUeOlTFateMKEJgxgwQjUy7Pm0BCPYxt0
dllvIs18cq8pcHF9WUAGC/HdnkebpcTFKYXaM1C7wFVnlKVBgQZrnNIu0M9XzCKR
I1LHeK6lsYTXDSfMclczPSBuhEzckb+RYYssvzgwCHtAfPuiTSUt0Dd1hm8fvI+1
6bfqfyx6UIvm5tPuLaaN7wSdA+X+68Fj1ZSYAA8VfttOMzpkqAtpRb6tEQhdRIlc
dh1sUtummvA=
=0tdI
-----END PGP SIGNATURE-----

--------------enigB046C7E2E25F33ECE5D1B05B--
