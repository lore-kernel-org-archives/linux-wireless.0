Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35557 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYJaQYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 12:24:50 -0400
Subject: Re: Guidelines regarding separate directory
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Pavel Roskin <proski@gnu.org>, Dave <kilroyd@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <1225469608.27440.11.camel@localhost.localdomain>
References: <4909EA78.3060700@lwfinger.net>
	 (sfid-20081030_181107_189082_5740895D) <1225387309.3690.73.camel@johannes.berg>
	 <490A17F3.5050802@gmail.com> <1225399481.7931.5.camel@dv>
	 <1225399682.3690.82.camel@johannes.berg>
	 <20081030231054.ehd21qipcow4kg88-cebfxv@webmail.spamcop.net>
	 <1225447269.3535.4.camel@johannes.berg>
	 <1225469608.27440.11.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0xOzdMjTNmMtjf/ahSkj"
Date: Fri, 31 Oct 2008 17:24:31 +0100
Message-Id: <1225470272.5546.12.camel@johannes.berg> (sfid-20081031_172455_221260_366CB073)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0xOzdMjTNmMtjf/ahSkj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-31 at 12:13 -0400, Dan Williams wrote:

> > No, that's not true, just see
> > http://bugzilla.kernel.org/show_bug.cgi?id=3D11802 for example. The AP
> > part also duplicates a lot of mac80211 functionality.
>=20
> Orinoco is a mostly-fullmac driver, while hostap is quasi-softmac,
> right?

I thought hostap was mostly fullmac for STA mode, and softmac for AP
mode? Not sure though.

johannes

--=-0xOzdMjTNmMtjf/ahSkj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCzE8AAoJEKVg1VMiehFY12UQAMRTUDnh9hCh5WkSi0rB0CIM
T17Dgb+8ISUMX59S22gGq99RJiRFeOmigcIvls0EnVBCcyB+RKrbe/hGy52Dh92I
3FPe+WoFgYr9GNM2kl7cMcmTJjhnsOfwisnaaKWtINrCtakOWPX10djbljqEf4RC
AWIlweZ3XF6cHatUtoi6hvv4XmKzoyAbd8r+PMD6vCW8xVAOZR9eHzw/cXLF+JjG
+dtZBhJLXqq0Y/7WrTtWwKZreLTkajfgBfC9ezajVtOen5V4Skuha7aBC/H7R8HR
XqbQWAz3vNpkRP0a7IJp+UnP0CWumMNCFSJilKd2qrZIo8SakLcl1F1adu9Gfg8Z
J75RjHy58EZ+lnso3aRFiWvGS3Vf7+Ept2Xv8zngdMZaUUvEG06A6+hFajZWwBU8
NNpqKeTVvSbYhX0m5uxEMSceve5j3XTspZvIilQtv2w0XD0+FFcoUmlKIxh2n0ga
KlE5FUiUBTOYAjyQfbKbz7HDm5Oel+QPi/LnrSkQYU/bI7lUfjNqK2Q+KcenzjLd
Ea1V7J3uFyHDkicWsB5bTnWAQ4hvcSyFhjQND7Mor4k/7d6AQIZz6ShE++x0ZX0n
aS7awN8t2EQY+ObSjdkVIZlalWsZ4y34hTahLeAZmo4ocU2QpgmU2ppm6yfQ/xc1
2tnt2rZXkzkZtFUsc7Ci
=nV5R
-----END PGP SIGNATURE-----

--=-0xOzdMjTNmMtjf/ahSkj--

