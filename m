Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:58944
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbZKBVKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 16:10:01 -0500
Date: Mon, 2 Nov 2009 13:10:01 -0800
From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
To: Frank Schaefer <schaefer.frank@gmx.net>
Cc: linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Message-ID: <20091102211001.GH24436@one-eyed-alien.net>
References: <200910171606.02961.oliver@neukum.org> <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org> <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net> <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de> <20091101183553.GB24436@one-eyed-alien.net> <4AEDEE7C.4010406@gmx.net> <20091102004756.GC24436@one-eyed-alien.net> <4AEF3BF8.1080701@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17/8oYur5Y32USnW"
In-Reply-To: <4AEF3BF8.1080701@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--17/8oYur5Y32USnW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 02, 2009 at 09:07:20PM +0100, Frank Schaefer wrote:
> Matthew Dharm schrieb:
> > I am thinking about the users.  Do you really think someone who has
> > difficulty installing a new udev rule (probably a line or two of text
> > copied from a google search) or installing a new version of usb_modeswi=
tch
> > (probably one or two commands to the distro package manager) will have =
an
> > easier time doing a custom kernel-compile and update?
> >  =20
> I think users should not need to do ANY of these things ! That's called
> usability.

So, new hardware should "magically" work?  When you can write software to
support hardware that doesn't exist yet, let me know.

> Which users do you think know how to create udev-rules and how to
> compile a kernel ?
> Of course you and me and likely all others on this mailing-list and
> maybe you think Linux should be for them, only.
>=20
> I think we should do as much as possible to improve Linux-usability for
> "normal" and even "less experienced" users.

Okay, let's talk about "less experienced" users.  Suppose you are one of
these users.  You get a new device, and you want to use it.  You do some
web searching, and discover either:

(a) you need to download and recompile your kernel
(b) you need to cut-and-paste some text from a web page into a file

Which do you think is easier?

And, the situation above pre-supposes that the requisite changes (kernel or
userspace) haven't already been picked up by a distro maintainer.

> And in this case, it would be really easy.
> > Updates in userspace are universally easier; on users, on kernel deves,=
 and
> > on distro devs.
> >
> Why ? Of course, the benfit for kernel-developers is that the work is
> done by others...
> But for the distros it makes life much more difficult in many respects.

I highly doubt this.  Distros must very carefully test all the kernel
changes they decide to pull in.  Each and every change in a kernel-layer is
a high-risk change for them.  Changing userspace packages is much
lower-risk, and thus consumes correspondingly fewer resources.

> And users are in the somehow insane situation that they have to keep the
> driver (kernel) AND the "key to be able to use it" up-to-date.
> That's not only a problem because they both things from different
> sources/directions !

I think you may have missed part of an earlier discussion, wherein we
discussed such devices which would NOT need ANY kernel changes.  The idea
was that udev could "eject" the fake-USB device, then add the device IDs to
the serial/cdc_amc/whatever driver dynamically, at runtime.  Thus, no need
to make any kernel updates at all.

And, that system works *today* with the existing kernel code.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Okay, this isn't funny anymore! Let me down!  I'll tell Bill on you!!
					-- Microsoft Salesman
User Friendly, 4/1/1998

--17/8oYur5Y32USnW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFK70qpHL9iwnUZqnkRAt+JAJ9uukAquCusn8F1GVVzGx4H30GSigCgm1+q
YjjRF00/tf/JKFSE7JYaVSU=
=nx9k
-----END PGP SIGNATURE-----

--17/8oYur5Y32USnW--
