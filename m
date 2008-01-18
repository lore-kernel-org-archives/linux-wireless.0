Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:49339 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760029AbYARVNd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 16:13:33 -0500
Received: from ironport-out-2.rz.rwth-aachen.de ([134.130.3.59])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JUU00CZ0XJ2XH70@mta-2.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Fri, 18 Jan 2008 21:42:38 +0100 (CET)
Date: Fri, 18 Jan 2008 21:42:27 +0100
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: iwl3945 driver is still unusable!
In-reply-to: <D936D925018D154694D8A362EEB08920036F286F@orsmsx416.amr.corp.intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Message-id: <47910F33.2090505@archlinux.org> (sfid-20080118_211343_484455_206D31B6)
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enigDD56BEAE49A2A8827BC9264D
References: <fmclu6$dvl$1@ger.gmane.org> <fmpigk$c57$1@ger.gmane.org>
 <D936D925018D154694D8A362EEB08920036F286F@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDD56BEAE49A2A8827BC9264D
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Chatre, Reinette schrieb:
> On , Thomas B=E4chler  wrote:
>=20
>> Thomas B=E4chler schrieb:
>>> What I need is a solution, meaning either a working iwl3945 version
>>> or a patch to ipw3945 to compile with 2.6.24.
>> I was hoping for someone from Intel or someone with knowledge of the
>> code to comment on both these issues:
>>
>> - Can ipw3945 be modified to compile with 2.6.24?
>=20
> ipw3945 is deprecated - we focus our effort on iwlwifi at this time.

Which doesn't help anyone if it does not work. ipw3945 may be deprecated
in your eyes, but for me it is the only way to make my wireless NIC work
reliably. From my point of view ipw3945 is stable and iwl3945 is _alpha_
software.

>> - Can the newest iwl3945 from the website be modified to compile with
>> 2.6.24?
>=20
> iwlwifi is included in 2.6.24 so you can use it from there. If you are =
interested in the latest iwlwifi development (more recent than what is in=
 2.6.24) then you can work from John Linville's wireless-2.6 (#everything=
) repository.

It is, but if you read my E-Mail, you will notice that the driver
included in 2.6.24 is unusable, thus my request to use a newer driver
with a _stable_ kernel. The wireless-dev is based on the latest
linux-2.6 git, which is not always stable.


--------------enigDD56BEAE49A2A8827BC9264D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkeRDzQACgkQEda5KzHP/VA2LACgwc3OT6QqSoNWxj5rDCvTRBKH
ktEAoLXxoDyX388rGuIpf2yo9bGhVogk
=eD5F
-----END PGP SIGNATURE-----

--------------enigDD56BEAE49A2A8827BC9264D--
