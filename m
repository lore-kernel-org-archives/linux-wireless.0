Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from katherina.student.utwente.nl ([130.89.168.160]:38991 "EHLO
	katherina.student.utwente.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755655Ab0CaRll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 13:41:41 -0400
Date: Wed, 31 Mar 2010 19:41:38 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] [RFC] rt2500pci: fix powersaving
Message-ID: <20100331174138.GE21160@katherina.student.utwente.nl>
References: <201003290956.54234.linux@rainbow-software.org>
 <201003301433.55355.linux@rainbow-software.org>
 <20100330125620.GA2173@katherina.student.utwente.nl>
 <201003302209.23334.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8vCeF2GUdMpe9ZbK"
In-Reply-To: <201003302209.23334.linux@rainbow-software.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--8vCeF2GUdMpe9ZbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ondrej,

> phy0 -> rt2500pci_set_device_state: Error - Device failed to enter state 1 (-16).
I've been running with your patches (applied to 2.6.32.7) for a day of normal
work, and the steady stream of these errors has stopped. During the entire
day, I've seen the error once, perhaps a corner case here or there?

Overall, I have the feeling that connectivity is a bit more unstable with
these two patches, however. On a few occasions, my SSH connections would hang
for a bit. Sometimes pinging would be ok (and sometimes it wouldn't), so I
haven't quite figured out if these problems were actually caused by the
driver, or some other cause). Once I seemd to solve the problem by turning off
powersaving, but that might have been a coincidence. Other times the problems
went away by themselves.

Is there anything else I can do at the moment I'm seeing connection problems?
Make a register dump or check some command?

I'll do some more testing, tonight on another (probably more stable)
connection.

Gr.

Matthijs

--8vCeF2GUdMpe9ZbK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuziVIACgkQz0nQ5oovr7zHaACfWdorn1rQDXr7NAY13AcjDcsG
8xkAn1oiM0FF2GPGDAuh8YEwbZ6Bc+Vi
=pfCH
-----END PGP SIGNATURE-----

--8vCeF2GUdMpe9ZbK--
