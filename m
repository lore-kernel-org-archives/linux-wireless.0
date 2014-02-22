Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:55924 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaBVMs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 07:48:58 -0500
Received: by mail-ea0-f182.google.com with SMTP id r15so2117557ead.27
        for <linux-wireless@vger.kernel.org>; Sat, 22 Feb 2014 04:48:57 -0800 (PST)
Received: from pendrak.localnet (093105044227.oswiecim.vectranet.pl. [93.105.44.227])
        by mx.google.com with ESMTPSA id k6sm38527646eep.17.2014.02.22.04.48.55
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 22 Feb 2014 04:48:56 -0800 (PST)
From: Mariusz Fik <fisiu82@jabster.pl>
To: linux-wireless@vger.kernel.org
Subject: Re: /suse_update_desktop_file and Categories
Date: Sat, 22 Feb 2014 13:48:54 +0100
Message-ID: <6225254.q9g9eENvKF@pendrak> (sfid-20140222_134901_478940_AA5A44BB)
In-Reply-To: <2171888.3xJjAhnGjq@pendrak>
References: <2171888.3xJjAhnGjq@pendrak>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3897443.eWsUhf9u0D"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart3897443.eWsUhf9u0D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Dnia sobota, 22 lutego 2014 13:28:16 piszesz:
> Hi,
>=20
> I'm trying to build kprinter4[1] package.
> According to desktop file category guidelines[2], I included in spec =
file:
>=20
> %suse_update_desktop_file -r %{name} Utility Printing
>=20
> But then build failed with:
> WARNING: Category "Printing" is unknown \!
> ERROR: No sufficient Category definition: {path_to_desktop_file}
> Errors in installed desktop file detected. Please refer to=20
> http://en.opensuse.org/SUSE_Package_Conventions/RPM_Macros
>=20
> Where is a problem and what it's more important, what is a solution? =
Our=20
wiki=20
> page with desktop menu categories are outdated? build/check tool issu=
e?
>=20
> [1] - https://github.com/credativ/kprinter4
> [2] -=20
> http://en.opensuse.org/openSUSE:Packaging_desktop_menu_categories#Uti=
lity
>=20
I'm so sorry. Wrong list. Please ignore this message.
=2D-=20
Pozdrawiam / Best regards,
Mariusz Fik
openSUSE Community Member
GPG: 5FCE 7241 B3B9 32FD 455B C30E 42D6 6C88 9E83 7C3D
--nextPart3897443.eWsUhf9u0D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlMInLYACgkQQtZsiJ6DfD0qhACguZ6vGPGyBF52WiS3YUYawuRr
epcAnR/flPGrlPK39LeiSpZ/Q/OefGD7
=ne/R
-----END PGP SIGNATURE-----

--nextPart3897443.eWsUhf9u0D--

