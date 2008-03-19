Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58627 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765536AbYCSUPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 16:15:53 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20080319201004.GC5308@jm.kir.nu>
References: <1205781593.16475.20.camel@johannes.berg>
	 <1ba2fa240803171239l6b07ba4ch2b2aaca5e7fa0506@mail.gmail.com>
	 <1205784255.16475.33.camel@johannes.berg>
	 <1ba2fa240803171327r4c817228kc4f248abf0a0cea@mail.gmail.com>
	 <20080318080435.GA5308@jm.kir.nu> <1205831880.16475.43.camel@johannes.berg>
	 <20080318102344.GG5308@jm.kir.nu>
	 <8704f27d0803190942h19b5a9ebjd3b27537c30ef719@mail.gmail.com>
	 <20080319173922.GB5308@jm.kir.nu>
	 <1ba2fa240803191141y7feae800g607432f2e9628e37@mail.gmail.com>
	 <20080319201004.GC5308@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mBmBaRuZFahPwLmnxC5y"
Date: Wed, 19 Mar 2008 21:15:27 +0100
Message-Id: <1205957728.16475.72.camel@johannes.berg> (sfid-20080319_201645_216986_ABA016DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mBmBaRuZFahPwLmnxC5y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The IEEE 802.11 name for this would be "default key". IEEE 802.1X (or
> well, RFC 3580 is the authoritative specification for this) calls it
> "broadcast (default key)". Please note that this is not really a key
> that is always used both for unicast and broadcast. If there is a
> key-mapping key (unicast/individual) for the matching
> transmitter/receiver addresses, that key will be used instead. The "old
> WEP key" way of using only statically configured default keys just does
> not set the key-mapping key and because of that, the default key ends up
> being used for all frames (or well, one of the possible four default
> keys).

That agrees with what I did in mac80211, but not with Intel's hardware.

johannes

--=-mBmBaRuZFahPwLmnxC5y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+F0XqVg1VMiehFYAQIa5Q//dsJBwboxj3BqyO+vlDoVccAG3aM3IpwE
OH95mR67PUJXeSrDqTvfOe09jen3EoRkoin71mId4IwhlNKIl3pzI8uQGiUN+K5c
yud4uzBNfqJ7Fp33YOBF0sRy49ooYJLSxnx/kjrdEpZxS43uUIlsKzdi1i2FZOjS
bzBdQWbxbzaQzqrtiuIZ8OmPXFR+GEXtD3whJmnyoVChKMx8aYZwSewXz1z8dh5Y
RhhDF4zL7AdidfqKmpuREM27w+2i2omkhIfp0dQBBOWhD5JO1If+stxNwcIZBrT+
/KjX8oGvn9LcXVPbyCVOrSnoLvvFdfTdaq7MUONUi3K13i2kAKQ37WO0QEJ7zOYH
TTIQ+bgiEDgvqGQRO2VoVbROcy3ijKwX4ruVmP+ropru9HNmEGHra60/XpXpdV4Z
NBnUI0dDc+67Rt7hjqiP38oICMVE41YjSq8FIUz1iYWvD7RCiz2s9wd9ZIhbP906
CTRtX2fc11Y/NlnzYWmS9IcAWFz9Kb2wyorbZSiA9p5e64sNR+1TBTznBodWhNkn
qnJ/W5ByN0DtnHZSJMhe4P72GsIjIRlE5wGmGXa2sDazhy79xKQ6Iyd8AoimPF60
YUJNJGNHxTTuRbBgJqAcqZ25WRz8a+m+WEJ1LR7LDVUYr78HqIeOtP2cCmhSTFRP
TOYgdMyStuU=
=hm/3
-----END PGP SIGNATURE-----

--=-mBmBaRuZFahPwLmnxC5y--

