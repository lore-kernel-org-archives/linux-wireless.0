Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from orca.ele.uri.edu ([131.128.51.63]:42244 "EHLO orca.ele.uri.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbYHYEh2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 00:37:28 -0400
Date: Mon, 25 Aug 2008 00:37:05 -0400
From: Will Simoneau <simoneau@ele.uri.edu>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Yousaf Jindal <yousaf.jindal@pi.edu.pk>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ANNOUNCE] Wifi Link 5300 and 5100 Series
Message-ID: <20080825043705.GA16061@ele.uri.edu> (sfid-20080825_063733_261826_657E93AB)
References: <e700089d0808151307j27d6c61dw3a1dd174e4e8610c@mail.gmail.com> <e700089d0808160326k337cec2dm65271b38812a4263@mail.gmail.com> <1ba2fa240808180112l284086f4x64168d994743398@mail.gmail.com> <e700089d0808180315s4851ed0fqea6b64c83eb570f@mail.gmail.com> <1ba2fa240808180547md32b43au7b1beaccab1f5fd6@mail.gmail.com> <e700089d0808180943m1bc403d4v3ee578a81e2d96cf@mail.gmail.com> <1ba2fa240808181642h61fb2d74ja96dd3860fb5d4e6@mail.gmail.com> <20080821073140.GA18961@ele.uri.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
In-Reply-To: <20080821073140.GA18961@ele.uri.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > It will take a while till I get this Laptop so one more request which
> > I should  actually start with is to send me your kernel config file.
> > (personally I prefer attachment instead of inline mail)
> >=20
> > Thanks
> > Tomas
>=20
> The patch does not help in my case either. .config attached.
>=20
> # cat /sys/class/net/wlan0/device/version=20
> fw not loaded
> EEPROM version: 0x11f

[snip .config]

I was just playing around with the driver a bit, and I turned on debug
mode. Somehow, the interface came up and scanning worked - once. It
hasn't worked again, with debugging both on and off. I have the log
messages from when it worked, let me know if they might be useful.

I was testing without the additional patch, BTW. Just the vanilla
version from the git tree, iwl5000 branch.

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiyNvEACgkQLYBaX8VDLLVwiQCeKVIXBq6TPAp7Hko0KLRMTrLJ
yNgAoL7Ic0LsmqTWNNDlmRXWNlrV0A7r
=QFaG
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
