Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:57190 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbZKZUNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 15:13:05 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] API for setting ACK timeout
Date: Thu, 26 Nov 2009 21:13:10 +0100
Cc: linux-wireless@vger.kernel.org
References: <200911261826.08576.8an@praha12.net> <200911262015.03106.8an@praha12.net> <1259263540.24540.9.camel@johannes.local>
In-Reply-To: <1259263540.24540.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1553928.F8ZZZseMbC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200911262113.10847.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1553928.F8ZZZseMbC
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 26.11.2009 20:25 Johannes Berg wrote:
> My standard reference was obviously crap -- let's see, 7.3.2.9 is
> better.
Yes, I found the table. And now I also noticed the real difference: the slo=
t=20
time according to the standard rises in a step of three (which means ACK=20
timeout will rise in a step of six). It's quite significant loss of=20
precision, but it probably shouldn't make much difference in throughput.

Anyway, this solutions would be good enough for us if it was accepted. So y=
ou=20
propose to add parameter NL80211_ATTR_WIPHY_COVERAGE to nl80211 and functio=
ns=20
set_coverage/get_coverage to cfg80211_ops?

Lukas Turek

--nextPart1553928.F8ZZZseMbC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLDuFWAAoJEEBjvk/UOfYwTIsQAIJoY0knE1YN7q6m20qhx7qO
4uD6w8FYWPTV4zvyBjKwqx7AUG+SqyEOwSaCCo1dSbS0MKMg3cqWF3+yObwwn4eN
ZslFdKVHdDNg1OLYHvqcAQIxO7PCfBN1unZYour5/adG9LC+DApCsSZtfCAIbpI2
UQFarMtyzxbSPN72J/Cfd4GN3l0Uo9l3YKiAXF73UPruULz9fkh3dcnPuLPCvRSh
dx+W2nHw7CTcCjFPdyIDAD2wn4zI4j1LhlyLSG9cGweBeqlRx3llN4TYl2XiT73e
V/QJ8/pQTZ7cObWlwpiER4VQz0AwNGXum34oBgPI+pIsJ0wjLYpVDBS+1UAXccm6
n/RM3sbLkrrC21BHIiqwQF8Rxjw8PM3kz2M+i3IMrD8pC0xptE9BV/A5XLCJhtJD
BiEGOK8Bh4ITQSMj1GWjgymdB/3I3gO1heDZNePDwBiY4E8OVqW14E6TEkD5NvhL
Qr3UHPLyA/VcUTE9f0kUj/Ag0DPq2ZlEulLED8Jb2hjZPEVy31YQxNTSxgqmFbU4
6zePkDLMh2y+TTpFPYt9ZLAIDBmqxceR0fczIb3wIPW7q3jvxUP0tT5Qf5CUaZ7G
haB6tzzL2b95It8vAx3prDsTnjOoWB8yuXkvbTH/5FH2dALjKVDoUZoNBCvL8p56
euRpgvNIZqF8yOf3jRt2
=HLx4
-----END PGP SIGNATURE-----

--nextPart1553928.F8ZZZseMbC--
