Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from katherina.student.utwente.nl ([130.89.168.160]:33906 "EHLO
	katherina.student.utwente.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355Ab0DCP2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Apr 2010 11:28:40 -0400
Date: Sat, 3 Apr 2010 17:28:34 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH] [RFC] rt2500pci: fix powersaving
Message-ID: <20100403152834.GP21160@katherina.student.utwente.nl>
References: <201003290956.54234.linux@rainbow-software.org>
 <201003301433.55355.linux@rainbow-software.org>
 <20100330125620.GA2173@katherina.student.utwente.nl>
 <201003302209.23334.linux@rainbow-software.org>
 <20100331174138.GE21160@katherina.student.utwente.nl>
 <4BB396B4.8090005@gmail.com>
 <4BB3988C.40902@gmail.com>
 <20100331190011.GG21160@katherina.student.utwente.nl>
 <4BB74C9A.40900@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QAdlk5ze2izLk3Ap"
In-Reply-To: <4BB74C9A.40900@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--QAdlk5ze2izLk3Ap
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Gertjan,

> Did you have the chance to test the patch and do you have some feedback if the patch
> helps improve the rt2500pci situation?
I've been running with all three patches applied for a while, and it does
indeed seem more stable. I haven't seen the powersaving error anymore either
(though I've not continuously checked for it). I haven't gotten any new
problems.

Gr.

Matthijs

--QAdlk5ze2izLk3Ap
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAku3XqIACgkQz0nQ5oovr7y7QgCaA46lVMC3R1PpjvfB84krAtty
/a0An2N7Xgws9A6W/Qic2E2Zq0VeO0W6
=stHi
-----END PGP SIGNATURE-----

--QAdlk5ze2izLk3Ap--
