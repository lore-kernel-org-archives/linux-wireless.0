Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46729 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbZKDQ0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 11:26:14 -0500
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N
 devices in cdrom mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Frank Schaefer <schaefer.frank@gmx.net>,
	USB list <linux-usb@vger.kernel.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0911041036100.2968-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0911041036100.2968-100000@iolanthe.rowland.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-++rqdUZXJvr9YyLmupHg"
Date: Wed, 04 Nov 2009 17:25:09 +0100
Message-ID: <1257351909.28469.97.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-++rqdUZXJvr9YyLmupHg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-04 at 11:16 -0500, Alan Stern wrote:

> Here's my first attempt at considering all the pros and cons.  Has
> anything important been left out?

[snip]

I think you forgot to consider the case where both the driver and the
mode switch code need an update to handle a new device. This is relevant
in the case where a new device shows up that needs mode-switching, but
even after switching has an ID that the current driver doesn't know
about.

It's not clear to me which case typically happens though. I suppose that
often enough it'd be possible to have a device that shows up with a
special driver USB ID, and then after you eject it comes up again with a
regular USB ID that other devices use too.

Input from people who have such switching devices could be helpful.

johannes

--=-++rqdUZXJvr9YyLmupHg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK8arhAAoJEODzc/N7+QmaBtIQAI0aFGhDjZwEGXNa4mSYao0s
vSOH4hTmG/fYhwLxYL/U7d/H+K0SOaibiyMhCC09/BGOQRwgGPPERVGh5+ue4pwY
V0SIkTco+HvRN/39uISZhfTCKezm4uLcAKBeT3bF3/GXoxD4JoRl9u9G3Lv5Rqso
EI1ny4HeVvRl//BRCoB0IpiyNqwZBFNZQKxvtsd4y7586hpknAj3G3+KXCIbVm1D
ulEUkCRol1Jnhs9pHDPas9HwHFOW6Bn0TzK15v1eGb99Idb0UfaXLKUFyOS2mkK1
fADYA++/cgMeQHCSOvyFAfWhWN0P8TcPQZEtJJcTuFpZ2P9YOuRmWOgJEx+UprLA
e6tjoMzW2Pmmaz124EjjX6RkY6ADN/u18a5nHE6/WHCey+jTbQP5TrJBSRVcSwWi
QuVxyFmHl0Fv+kagB6TGGFXoBdntk9Gpq/t5tFxUAP0K18yEOjAAOuRlGpNuKFCc
jvSJQaHjRIieJ6K9/yRnV1QoYGCUCDosulhEkAq87ACw4nQUmYzGZMIRI3XlU9mu
E6uMxTTlaJgPdNVDaoBXXtCzlh5PUtH8DhVL8PYKhYqMlxPk28EuNCfU/g+OkmUW
P+ac+FcLheOViFPwxnjkKLf2J55Tsjh0cM6NULv/7U6RxGALi4pj2o2NrE7uLTTL
Vm7cA8cnpDtP/lscsafd
=aDuL
-----END PGP SIGNATURE-----

--=-++rqdUZXJvr9YyLmupHg--

