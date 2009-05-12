Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:64794 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbZELSJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 14:09:16 -0400
Received: by gxk10 with SMTP id 10so244121gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 11:09:17 -0700 (PDT)
Message-ID: <4A09BB45.8070808@gmail.com>
Date: Tue, 12 May 2009 14:09:09 -0400
From: Will Keaney <keaneyw@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT v9] rfkill: rewrite
References: <1242030669.6930.10.camel@johannes.local>	 <4A09B130.9000106@gmail.com>	 <1242151180.3203.19.camel@localhost.localdomain> <1242151479.11924.4.camel@johannes.local>
In-Reply-To: <1242151479.11924.4.camel@johannes.local>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE7389654B9F1D3BCEEE59741"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE7389654B9F1D3BCEEE59741
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Johannes Berg wrote:
> On Tue, 2009-05-12 at 13:59 -0400, Dan Williams wrote:
>
>  =20
>>> Please leave rfkill-input available as a module, at least until the b=
ug
>>> I reported in my previous e-mail 'Soft Lockup With rfkill_input and
>>> thinkpad_acpi' is resolved.  Otherwise it will render Thinkpads, and
>>> possibly other systems, unusable with rfkill enabled.
>>>      =20
>> The problem gets fixed where the problem is at...  if the actual root
>> cause is in the rfkill rewrite, then maybe Johannes should take a look=
=2E
>>    =20
>
> We don't even know yet whether the bug is present after the rewrite!
>
>  =20
>> If the actual root cause is a bug in thinkpad-acpi, then it shouldn't
>> block the rfkill rewrite, but should be fixed in thinkpad-acpi.
>>    =20
>
> Unfortunately thinkpad-acpi hasn't been ported yet in my rewrite, so we=

> can't know. I've poked hmh, but if he doesn't respond soon I'll do a
> crude port and ask Will to test it.
>
> johannes
>  =20
OK. For what it's worth, the bug is still present in
2.6.30-rc5-wl-23297-gbf2c6a3 as pulled from wireless-testing about an
hour ago.

Will Keaney


--------------enigE7389654B9F1D3BCEEE59741
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoJu0kACgkQjfayWCA8dDHE/gCcD5KNWmOobhOBugI5ljjY0oQ8
8VUAmwf7IwPoKUFcEbs/e+Nzj+qPQLjD
=jvHB
-----END PGP SIGNATURE-----

--------------enigE7389654B9F1D3BCEEE59741--
