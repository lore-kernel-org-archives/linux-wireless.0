Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60704 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbYC0NlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 09:41:14 -0400
Subject: Re: mac80211: bad use of bss_conf.use_short_preamble
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Koutny <vlado@work.ksp.sk>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>
In-Reply-To: <47EB9F93.3060206@work.ksp.sk> (sfid-20080327_132233_178733_0CF971A8)
References: <47EB9F93.3060206@work.ksp.sk>
	 (sfid-20080327_132233_178733_0CF971A8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wWW0YcSwCi7MhHKhYBX5"
Date: Thu, 27 Mar 2008 14:41:11 +0100
Message-Id: <1206625271.22530.59.camel@johannes.berg> (sfid-20080327_134118_220521_CF331F91)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wWW0YcSwCi7MhHKhYBX5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> does anyone know what values were intended to be used for
> bss_conf.use_short_preamble? The way it is handled now is not
> optimal for sure:

Huh, I guess we screwed that up when converting it to bss_conf. The
WLAN_ERP_... values shouldn't be used internally nor with the driver and
be converted to the bool value.

johannes

--=-wWW0YcSwCi7MhHKhYBX5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+uj9aVg1VMiehFYAQKhaw//f0CxVXSzuUX42s2SIpQLMCu+h6YNrLMX
FZwx1XO/6uzEcPf1ub3sx7hLMp5pBDiebkg0F8kjYqf+8rA//FU0meTNbdqTnZDb
5+vTpmnbhLBW5dpEHaBA459+aIQf6XF68lxily9pMPk+1jrbcjA9d1R6pWIOdZ4s
qjT6L3nv67N/iV9NpVyiuGTuVnnyARWmlNTo0YQ1hJ448063n1X0FBGLuAiDT3ax
Cw/ytCGkg+ZiZugdkRoAqKL4PhkgYgrCJLu1FNzPs2aiKTF7zW5/DHchebVVsOuA
zF24YCeNR5C7UoD3p79J9MtGkziXpGfMrACcURlAShPfNwp8+hdBK7SzIhbE46wa
5u6zQICXlAHyl2Dn3GbSsQWoHKaNs0I2HWfA/I5NBFBdQ6ze9dEu8KsHUJZ496aT
tkLnhIG1eH3WjwTdbQlQhhJNU37MGBQMdnZfkA4wqPBJNkLayiXePfsm04pfoRvS
JrzA+JeRCnkbtyj7zhOlhiHyLwV/bRVmt9nijuEaBX7dj2kTFdwdBUpD71QI1Sf8
GwvvUlcxbtx5bEnhxUM7CBsxxDKZxwRPMKK9XjYtNBjyRNY2ho8gJmn1oWYuxAoo
12sWbIP+MRz81yJ7bNk0escKMtQVLLWefu2TqaBybUItLozJ7Qi9ZGjIM7wLzDHY
1gq9dcPXR4o=
=NsIg
-----END PGP SIGNATURE-----

--=-wWW0YcSwCi7MhHKhYBX5--

