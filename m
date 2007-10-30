Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbXJ3MIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 08:08:13 -0400
Subject: Re: [ipw3945-devel] iwl3945 lists supported rates backwards
From: Johannes Berg <johannes@sipsolutions.net>
To: mabbas <mabbas@linux.intel.com>
Cc: dragoran <drago01@gmail.com>, ipw3945-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
In-Reply-To: <4726433A.2070808@linux.intel.com>
References: <1192832109.19766.14.camel@dv> <47192F84.1020101@lwfinger.net>
	 <20071020014040.40pq9hqkw0c4owc8@webmail.spamcop.net>
	 <4719BA96.3010609@gmail.com> <1193644281.27622.12.camel@dv>
	 <1193667153.5197.48.camel@johannes.berg> <1193677095.11181.2.camel@dv>
	 <1193677748.5197.77.camel@johannes.berg>
	 <f6ca9fed0710291153o68ec2cffqbd2cc3f6d57fa11b@mail.gmail.com>
	 <4726433A.2070808@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UHMj30Jj0OrkUYi1DX51"
Date: Tue, 30 Oct 2007 13:09:26 +0100
Message-Id: <1193746166.3912.11.camel@johannes.berg> (sfid-20071030_120819_691374_DFF8544C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UHMj30Jj0OrkUYi1DX51
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-10-29 at 13:31 -0700, mabbas wrote:
> This might break rate scaling for 3945 adapter.=20

Yeah I was just going to say the same, the rate scaling is a bit
awkward.

> I look into rearrange=20
> the rate and do what ever needed to make rate scaling wont break.

Thanks.

johannes

--=-UHMj30Jj0OrkUYi1DX51
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyce9aVg1VMiehFYAQLwiBAAvs95WkrJIVQHsAbd5j0iRrSqsMDZOuoq
kHzfJPkoiy5+7kaR8RHyqVB4Yy5pB/ZlYkyOMZ0s7qEnNSHFDUub3JwHzjTRvuho
T2UWvbIeTzN4olb/m0LJeEcpXBLbzXG283c6eoThdQ2gZrkNjCm0WOWgtNhKx/Eq
67pFiT8QQ3uB8ZV+2Z9cuzifZKBUBh0442uGlcPl/un+0j4cKZ+dYxGItFEikUv9
D8x1BSZtUS8blwcZQrp0FT1mVuq4FYwm0qYq9kHbnG3/1bxYbqKsqAP5jLBAKQ0S
E8CdSUnb+ugSLmxo1baFsWJcdd/CZAlHiKggmY+KlmySN3uTNXmelUTPWQPHN6QM
VfsjZi3JR1ULQRUieiZIwqKqEv/T1CD53mUMC0Ea+koOILAuEkCU8TH5PycmAf6K
80B3JaLQWlRBwg1s89IE+ZURoi3AS6yS9TlcSVRdKfcpQ2EoCGrzdxKuYA98Jvu+
BTQP4lSRzZtGRrg9iH0Pmq27OFkAKlKAmLXisQ+ZbUU9x+pizC0FeXD7FiEI1PdS
NH/6/7xZLwijRb25JwVrVObwToF1Xl4nW83IYTNAvl/2q35FD9jcJEwCRGZV1vnF
CvvC21/AV+4nQzPPMfFyikv162EqRypthFCr4wezYyBL99WyetmS87400HfyXd35
jVgv4NPrh1A=
=s3P9
-----END PGP SIGNATURE-----

--=-UHMj30Jj0OrkUYi1DX51--

