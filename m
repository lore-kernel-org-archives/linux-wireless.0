Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:54667 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaBVM2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 07:28:21 -0500
Received: by mail-ee0-f41.google.com with SMTP id e49so2163028eek.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Feb 2014 04:28:20 -0800 (PST)
Received: from pendrak.localnet (093105044227.oswiecim.vectranet.pl. [93.105.44.227])
        by mx.google.com with ESMTPSA id v6sm38337606eef.2.2014.02.22.04.28.17
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 22 Feb 2014 04:28:18 -0800 (PST)
From: Mariusz Fik <fisiu82@jabster.pl>
To: linux-wireless@vger.kernel.org
Subject: /suse_update_desktop_file and Categories
Date: Sat, 22 Feb 2014 13:28:16 +0100
Message-ID: <2171888.3xJjAhnGjq@pendrak> (sfid-20140222_132848_343616_EA78E8A8)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2575612.tSKi5VCTLy"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart2575612.tSKi5VCTLy
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi,

I'm trying to build kprinter4[1] package.
According to desktop file category guidelines[2], I included in spec fi=
le:

%suse_update_desktop_file -r %{name} Utility Printing

But then build failed with:
WARNING: Category "Printing" is unknown \!
ERROR: No sufficient Category definition: {path_to_desktop_file}
Errors in installed desktop file detected. Please refer to=20
http://en.opensuse.org/SUSE_Package_Conventions/RPM_Macros

Where is a problem and what it's more important, what is a solution? Ou=
r wiki=20
page with desktop menu categories are outdated? build/check tool issue?=


[1] - https://github.com/credativ/kprinter4
[2] -=20
http://en.opensuse.org/openSUSE:Packaging_desktop_menu_categories#Utili=
ty
=2D-=20
Pozdrawiam / Best regards,
Mariusz Fik
openSUSE Community Member
GPG: 5FCE 7241 B3B9 32FD 455B C30E 42D6 6C88 9E83 7C3D
--nextPart2575612.tSKi5VCTLy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlMIl+AACgkQQtZsiJ6DfD2sqwCfaevfsl+VnkcwRwXo9jakek+G
7dsAoJFNi11PKm2yetoUpmIGCo+aU7s+
=Oo5l
-----END PGP SIGNATURE-----

--nextPart2575612.tSKi5VCTLy--

