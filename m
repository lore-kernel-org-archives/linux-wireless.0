Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:37985 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab3HCQzY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Aug 2013 12:55:24 -0400
Date: Sat, 3 Aug 2013 18:55:04 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: b43: DMA errors with BCM4331 on BCM4706
Message-ID: <20130803185504.022b19d2@milhouse> (sfid-20130803_185527_431880_00E1200E)
In-Reply-To: <51FD218E.9040700@hauke-m.de>
References: <51FD218E.9040700@hauke-m.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/innf1FCEQeXhNZlg0x8=5zc"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/innf1FCEQeXhNZlg0x8=5zc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 03 Aug 2013 17:28:14 +0200
Hauke Mehrtens <hauke@hauke-m.de> wrote:

> I used wireshark to see what actually happens and the device send out
> beacons and answers to probe requests without problems. I see the
> Authentication, Association Request and Association Response frames and

That suggests DMA works for some packets and then fails?

> Does anybody have any thought on this topic?

You should print out more of the DMA values.

--=20
Michael

--Sig_/innf1FCEQeXhNZlg0x8=5zc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR/TXrAAoJEPUyvh2QjYsOgAIP/ipTsKhNtwE5Q51vkTkrIvYL
sS8h7detE5piv4dPEPvqNqm+4AyGZcP33PP9VlY8nPywDdk4JfirqqgQgv9ltqb5
mah85zHXJprwwjj38DAliff3gwcqlBaARgn76o/cYZFq+GhuWln2AefY/blGiVCT
kZlF5VmC51xupEomIiUbo+wrd4stslALhxHRvldaNDZxrzmFJsgCwlKRW2H8PJcp
RuGGC9aGGtoPYjVgJRRxalraJnK2z1b+xaDYLAqo4Th30EKIhPlASS5BkQIxgjUW
jDJBkrTu+9mYb6Zi05AnBAXkIkxmT0Bnb0vlF7p6tejmroiiRfveA/nSb8F/J7pA
fY190W4YBzMUlTZBVgJXE+3gsJ+K52AJ5AL9HFuSdx4fXP1jUp8r/O0Bn531DahC
v89k6buKNzDKVw8DjGbQTp/d8oqezTZ55QBtUepmTOEui+vuR7pkHR/SMbVugdcr
4YDAm4UZdga+ukcjOZj7BPg/hQht6kHmMIJEkA+uhm8tUX7AMFeSThCQ46kiLXg5
6oMOPm1LC+wdbUzYN0KeEMcCY4seTZXdpB91GuRBxG01Nfcy1+zX83hIKYr66ZV9
IKtHJRSyTqVwU7Cexh/E3L9M6HR7zjvdSRKOWBx952bAw8JVldgnkNcdNQqHnsgt
3ccPEYe94o1CodQTnGAb
=/1og
-----END PGP SIGNATURE-----

--Sig_/innf1FCEQeXhNZlg0x8=5zc--
