Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54722 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987AbYGaVem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 17:34:42 -0400
Message-ID: <48922FE2.70705@imap.cc> (sfid-20080731_233447_231421_3BD633ED)
Date: Thu, 31 Jul 2008 23:34:26 +0200
From: Tilman Schmidt <tilman@imap.cc>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
References: <4891D1B9.70703@imap.cc> <20080731163843.GB9606@kroah.com>
In-Reply-To: <20080731163843.GB9606@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3784D548A80710B077D6D3D7"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3784D548A80710B077D6D3D7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Jul 2008 09:38:43 -0700, Greg KH wrote:
> On Thu, Jul 31, 2008 at 04:52:41PM +0200, Tilman Schmidt wrote:
>> Commit 782e70c6fc2290a0395850e8e02583b8b62264d8, which went into
>> 2.6.25, broke AVM's closed-source driver for this device:
>>
>> ID 057c:62ff AVM GmbH WLAN USB v1.1 (cdrom mode)
>> ID 057c:6201 AVM GmbH WLAN USB v1.1
>>
>> Is there an open source alternative for that driver, or do systems
>> with that device have to stay with kernel 2.6.24?
>=20
> Please ask AVM, they have known about this for over 2 years now.

Please let's keep the politics out of this. I know who wrote that
patch, I know the agenda behind it and the discussion accompanying it.
Conversely, I'm sure you know fully well that I have no way of putting
that question to any relevant person at AVM, and even if I had, it would
achieve exactly nothing at all. I am not interested in such fruitless
political discussions. I have a simple question, to which I would like
a simple answer.

> There is nothing we can do about closed source kernel modules, that is
> between you and the company producing it.

I did not ask anyone to do anything about any closed source kernel module=
=2E
Your killing of non-GPL USB drivers is an irreversible fait accompli I
won't waste my time to discuss. I really honestly just want to know if
there is a way to use this device with a 2.6.25 or later kernel.

Thanks,
Tilman


--------------enig3784D548A80710B077D6D3D7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFIki/tQ3+did9BuFsRArj8AJoD90H4uMfFGIZml5Kqir+f1hQJ0gCfQ9Pf
Oz3NE/006s3I4p6wtB2pRBc=
=XjOs
-----END PGP SIGNATURE-----

--------------enig3784D548A80710B077D6D3D7--
