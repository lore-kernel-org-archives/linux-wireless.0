Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:38684 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699Ab0CLWWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 17:22:54 -0500
To: Pavel Roskin <proski@gnu.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Weird wireless/wpa_supplicant screw-up.
In-Reply-To: Your message of "Fri, 12 Mar 2010 17:19:41 EST."
             <1268432381.3596.12.camel@mj>
From: Valdis.Kletnieks@vt.edu
References: <7197.1268086939@localhost> <1268392481.4828.7.camel@jlt3.sipsolutions.net> <5220.1268430568@localhost>
            <1268432381.3596.12.camel@mj>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1268432548_4034P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Date: Fri, 12 Mar 2010 17:22:28 -0500
Message-ID: <6480.1268432548@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--==_Exmh_1268432548_4034P
Content-Type: text/plain; charset=us-ascii

On Fri, 12 Mar 2010 17:19:41 EST, Pavel Roskin said:
> On Fri, 2010-03-12 at 16:49 -0500, Valdis.Kletnieks@vt.edu wrote:
> 
> > So the root cause has something to do with params[idx].cipher being unset.
> 
> Sorry if it's obvious, but please make sure you don't have another
> wpa_supplicant running and there is no other software that tries to
> control the interface.
> 
> If you have NetworkManager, the device in question should be unmanaged.

No NetworkManager here, so that shoots that theory. There's just a
wpa_supplicant running and nothing else managing the interface.

--==_Exmh_1268432548_4034P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLmr6kcC3lWbTT17ARArSpAJ9ILKTYo1dDnrZ7aXh8+vtzKv+aAACdEEpU
gcfC+vIutc//OYBgAlp1+UM=
=WK6/
-----END PGP SIGNATURE-----

--==_Exmh_1268432548_4034P--

