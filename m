Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:42917 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3LCRTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 12:19:33 -0500
Received: by mail-ea0-f169.google.com with SMTP id l9so10298399eaj.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 09:19:29 -0800 (PST)
Message-ID: <529E129B.6080807@gmail.com> (sfid-20131203_181937_833078_54588395)
Date: Tue, 03 Dec 2013 19:19:23 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2013-12-2
References: <529CF2D6.1080008@gmail.com>
In-Reply-To: <529CF2D6.1080008@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="5w8vU20fe46piSkRljMOJUfxgw2VQDhVR"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5w8vU20fe46piSkRljMOJUfxgw2VQDhVR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable



On 12/02/2013 10:51 PM, Emmanuel Grumbach wrote:
> Hi John,
>=20
> This is the fixed and enlarged pull request for 3.14. It includes the
> patches in my previous pull request that was based on a bad patch.
>=20
> I have here a big rework of the rate control by Eyal. This is obviously=

> the biggest part of this batch.
> I also have enhancement of protection flags by Avri and a few bits for
> WoWLAN by Eliad and Luca. Johannes cleans up the debugfs plus a few
> fixes. I provided a few things for Bluetooth coexistence.
> Besides this we have an implementation for low priority scan.
>=20
> Note that I had to merge iwlwifi-fixes into -next to solve conflicts
> before they hit linux-next.
> Please let me know about issues you may face - Thanks!
>=20

So - I found out that merging iwlwifi-fixes wasn't a good idea... So I
updated my tree and added a trivial compilation fix.

New head: 2f579448f3a60c8ede544dd0951b8d2a2e282ba2.

I hope that I have done all the possible mistakes now and that next time
I will get it right the first time... Sorry for all the mess...


--5w8vU20fe46piSkRljMOJUfxgw2VQDhVR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSnhKeAAoJEC0Llv5uNjIBIxAP/1NmW1dt9G4jfgLB4d/I0TYs
3dzKk9Xy2tqtfnZKywJAiWG4fVKTyKVWU2OsZJJkYZfUoxGKAURkDIOXpNKf1NTH
3GHUJv23C8YjBQ/bLLTo3WoGsnKrvg9Nq/XE1oTOnTSNY47ij1GrPpkh2nbG01JH
IlMg1Q4+dVwyZzhIlp6lnrUZRYa1ScUzYpN8mSxg3GP3qedfC/yKXq3Oz1NcSE6/
7y6/aXLDP37i+4vD27BmIM4KEAWvNrvrZxO+cGpZj7DRIk7LjA0LoXEDSg2N7MyF
/L62XdjJ1ob6CYBoIqAtraaE1WvJq7TpMlx6e8xY1R7YGLZrBFCmyCrE0f0X2dfd
LKw1+SBXferLYNfF2SL1Fco8b6URUMvcD9k/JbnL7nvUtSkWdy/VHf7sBKuGtCn0
oejWK1gxroX7gi0M/LR+qqce2ypQxXnnTLqVZQ8o+PPxt0iT3GOPA7HhtgbBi+jS
u528qfFPP5tgz/wuiFU/UFoJ/Jaq6uCHBNinghaTPa1x4gcR2P+GGnk+CiKSqbd/
eAU1HeK0Fgl9ipU2BweOwSuegVfsWtiYqW80mkF3dvrrni5fpKJ8OVXaxZ6/vIxH
g5mdT/ugslu2MwHlplrpInHPJtPmpDGQj8XJTbtOnD7XQoBYANLc5Hc7Y7aeOQvy
tE58lex0DqyxpwcpMUA0
=e947
-----END PGP SIGNATURE-----

--5w8vU20fe46piSkRljMOJUfxgw2VQDhVR--
