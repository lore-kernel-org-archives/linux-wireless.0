Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35140 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755645AbYGaWz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 18:55:28 -0400
Message-ID: <489242CF.2000100@imap.cc> (sfid-20080801_005539_875388_6DB5388B)
Date: Fri, 01 Aug 2008 00:55:11 +0200
From: Tilman Schmidt <tilman@imap.cc>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
References: <4891D1B9.70703@imap.cc> <20080731163843.GB9606@kroah.com> <48922FE2.70705@imap.cc> <20080731215055.GB4817@kroah.com>
In-Reply-To: <20080731215055.GB4817@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig20EB5BC271993523A77F46F9"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig20EB5BC271993523A77F46F9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Jul 2008 14:50:55 -0700, Greg KH wrote:
> On Thu, Jul 31, 2008 at 11:34:26PM +0200, Tilman Schmidt wrote:

>> Please let's keep the politics out of this. I know who wrote that
>> patch, I know the agenda behind it and the discussion accompanying it.=

>> Conversely, I'm sure you know fully well that I have no way of putting=

>> that question to any relevant person at AVM, and even if I had, it wou=
ld
>> achieve exactly nothing at all. I am not interested in such fruitless
>> political discussions. I have a simple question, to which I would like=

>> a simple answer.
>=20
> There's no "politics" here at all.

Oh, please ... You aren't seriously trying to tell me there's a *technica=
l*
reason for changing EXPORT_SYMBOL to EXPORT_SYMBOL_GPL, are you?

Again, I am not interested in discussing that decision. It's been taken,
and I accept it. But let's call a spade a spade.

> And why wouldn't you go ask AVM, they are the ones producing the driver=

> for this hardware, how could it be our responsibility to get their code=

> to work properly, when we have absolutely no way to do so?

That's not true. Reverting commit 782e70c6fc2290a0395850e8e02583b8b62264d=
8
would be enough. But again, I am not asking for that. My question isn't
about getting AVM's closed source driver to work with kernel 2.6.25+.
I just want to know whether there is an open source alternative, nothing
more.

> This is between you and AVM.  I really suggest contacting the company.
> I have talked to them in the past and they seem willing to help out
> where they can.

Obviously even you weren't able to convince them to convert their driver
for this device to something compatible with post 2.6.24 kernels. How
then could I possibly hope to achieve anything? I have no contractual
relationship with AVM. I don't know anybody in that company. I don't work=

for anyone they would recognize. All I can do is contact the regular
consumer support people who don't even know what I am talking about and
keep asking me to boot Windows, where the device obviously works, so all
is well, no? After all, it does say "System requirements: Windows" on the=

box.

But all this is just the fruitless discussion I wanted to avoid. With
your kind permission I'll stop this here and concentrate instead on the
subthread which actually deals with my question.

Thanks,
Tilman


--------------enig20EB5BC271993523A77F46F9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFIkkLbQ3+did9BuFsRAhl5AJ0YesA/ctLupGk/VoLjvra+pYxIHQCeM/mO
bkkCCFoF85r7L7Kcys4vq38=
=/zYk
-----END PGP SIGNATURE-----

--------------enig20EB5BC271993523A77F46F9--
