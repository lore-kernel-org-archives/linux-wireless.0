Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55450 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbYJ3KOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 06:14:07 -0400
Subject: crash with rt61pci when resuming with card ejected
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nkj9JhQ0V8qtGjicfoIt"
Date: Thu, 30 Oct 2008 11:12:33 +0100
Message-Id: <1225361553.3690.3.camel@johannes.berg> (sfid-20081030_111412_723748_0F939DA0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nkj9JhQ0V8qtGjicfoIt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Maybe it was stupid, but with USB it always works, I suspended, ejected
the card (because I had to go and didn't want to resume) while suspended
and resumed when I arrived at uni, to find the laptop crashing.

http://johannes.sipsolutions.net/files/rt61pci-resume-crash.jpg

Sorry it's so unreadable, there wasn't much light and I only had my crap
cell phone.

Here's some of the backtrace:
NIP: rt61pci_mcu_request
LR: rt2x00leds_unregister_led

rt2x00leds_unregister

johannes

--=-nkj9JhQ0V8qtGjicfoIt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCYiNAAoJEKVg1VMiehFYa/cP/0ahUKdwqH27c2p6uTuyFZEc
r7jzd9n/BbPg037ofkGolcD0y9YjDLwt8UVei1ZeK1RJtqwzwvduOHXMTbOmBJvv
W0+Q7yCAFsb0pfGVh0DWDUS910lnbxmfRRXJ897I2LiQ7nT0vRHddvOaGxbjM+bO
as5Och2uGxrUJlqwxkQlucF0w+NRCT6zMiscUrlBUPQjCNOQljU4gWGoI4jr4tpn
Xa/deeaH5bgdRdDjK3HSpopI11cQutuDA09iZEtsmdjBbEPXB30PDc5Qf3drrwFa
Tn+CJhDJzJhhTMw4Qi+5kKs3i1SlZAh6xEkqE/uS+sv0GiVVbrHFz77xNQFMi+6V
MrzeKP/ybxrjcuUMrUJDTJ2HloHbNfZ/JKVBWouNQyHtmAQ9XZapTyU81ZQ9NnEz
uRn29uKrSzxItSBG+Vl0H/W8KUGBunmZ0J58qaAt4EhlTFJFFdATZuQumsjdf9mr
2U9Hu46hK1tN7t4ophEOgO4Tl7aWXOp368i1mmhl03P1go+2nm53OWdmxtfJblQj
uM4f34i0PKKBren8kVSp+c7O+2H6gyoCorBYSSzBU9JH1vhh/ab4LZbxzpEwKEUa
wqM5oBxlxBwnI2mAFGRrbymA5WQ0tbghCqKgTQjd2rzY5AfE7uisk7ZWgNY30uIY
Nv+iC8lZYXHCHLh9ZU5/
=ueBG
-----END PGP SIGNATURE-----

--=-nkj9JhQ0V8qtGjicfoIt--

