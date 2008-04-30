Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-roam.Stanford.EDU ([171.64.10.152]:48487 "EHLO
	smtp-roam.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbYD3BFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2008 21:05:05 -0400
Received: from localhost (SW-90-728-259-1.Stanford.EDU [171.66.159.123])
	(authenticated bits=0)
	by smtp-roam.Stanford.EDU (8.12.11/8.12.11) with ESMTP id m3U153t7023120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Apr 2008 18:05:04 -0700
Date: Tue, 29 Apr 2008 18:05:02 -0700
From: Gautam Iyer <gi1242@stanford.edu>
To: linux-wireless@vger.kernel.org
Subject: b43 LED status (was Re: b43 reduced performance in Linux-2.6.25)
Message-ID: <20080430010502.GA17871@stanford.edu> (sfid-20080430_030504_906708_AC8B4530)
References: <20080429215629.GC17790@stanford.edu> <4817A28E.2050309@lwfinger.net> <20080429233045.GA26484@stanford.edu> <4817B548.30303@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
In-Reply-To: <4817B548.30303@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2008 at 06:54:48PM -0500, Larry Finger wrote:

>> I don't have Windows so can't compare to it. But even though I use b43
>> by default, I sometimes have to revert to ndiswrapper on weak signals or
>> large file transfers. Also ndiswrapper has the power management and
>> LED's working correctly, which I could not get working with the b43
>> driver.
>
> What LEDS does your interface, and what do they not do? If the only
> LED you have is the one attached to the rfkill switch, then you have
> not properly configured the LED parameters.

Yes, the only LED I have is attached to my rfkill switch. It becomes
blue when I load the b43 kernel module, and becomes red when I unload
it. I was hoping I could set it so that it becomes blue when in use
(i.e. associated), and red otherwise. (This happens with ndiswrapper).

I remember messing with the LED power / brightness files in /sys. But
nothing I echoed in there changed the state of the LED. Is there some
parameter I'm missing?

Thanks,

GI

--=20
Twenty Ways To Maintain A Healthy Level of Insanity
7. Finish all your sentences with "In Accordance with the Prophecy."

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkgXxb4ACgkQ6plSLtsExHGROACfVYPq7iRN2dQWqyXatJyDCrh2
KmAAni/H20nuRiflK/sEQERhMkUa55Jw
=KAi+
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
