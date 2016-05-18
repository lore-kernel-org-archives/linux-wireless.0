Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:45006 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbcERJge (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2016 05:36:34 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Bob Copeland <me@bobcopeland.com>, andy <lgkbiti@163.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wifi driver crashes openwrt device
Date: Wed, 18 May 2016 11:27:48 +0200
Message-ID: <7546204.U6Dr6cmRjt@bentobox> (sfid-20160518_113637_925790_2DB2BA3C)
In-Reply-To: <87d1omp6o0.fsf@purkki.adurom.net>
References: <loom.20160510T171307-937@post.gmane.org> <20160515174705.GA11620@localhost> <87d1omp6o0.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1644669.FN7hmrolrd"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1644669.FN7hmrolrd
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday 16 May 2016 14:46:07 Kalle Valo wrote:
[...]
> Didn't openwrt have a some sort ramoops facility to collect the last
> kernel logs before a crash? I don't recall the name right now but I'm
> pretty sure I used it with one of our APs few years back. That might
> help (or not).

He can just check if /sys/kernel/debug/crashlog exists after the device
crashed+rebooted.

I would also be good to have CONFIG_KERNEL_KALLSYMS=y set and compile the
kernel+modules with "KBUILD_CFLAGS	+= -fno-optimize-sibling-calls" to get
a (slightly) readable calltrace on things like MIPS.

Kind regards,
	Sven
--nextPart1644669.FN7hmrolrd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXPDWUAAoJEF2HCgfBJntG3EQQALCSdk+qZKlYQTGdnFZVgTFN
k6y5fJGbsjTPxD9B0kY8+GAZ1cJYhSMmnlFHuJXaaxGt3x9lb0VI7q7HPpV0YD3t
W0WhIA6SD0Xvd/mo6y52s0m7pDT0pSD4LxT6lmikBpiRMhAk68jaKsxUb9HNY+bf
Ph+OwR4Y1u1vbe8X4eaZEwM7l2qV/fQGitNh5ZQF9iM35P8o0R9su6O/p9VzufMI
KXv3lDitV1a3E+QdenK/2fFEkpzvFY7kN5iOkiigf/L6Dk+aJMsPvyx9GGq/50un
Hi0e/dI3nyvtqOZ2YO5JGzBdDxVjUs27hgtfjWqGF9CYfG7SJa4MUDcULLmIJcaX
rYDwLAsXn4UaX8klM6TtvNZUAo009q/gQoPH64n3Xqm4P9AqwaReagIMOGtwr1M6
yH0cF1CAzOUobGf2J39c9dtkO7d/wbuDYHmAtzXuefJ3Ur3eMwAnLa5ghw28zZz9
ClAT/9Sx2rLxV914Tb+bzmnneanzEY9XRNGzlYJc27Es6qCOkS0vqQmrCn5Xrm/6
xWDcsUdqeDD5W0EPzAuheMav7ysOKgGMtFYCa86I5wR9+WHUWOBMTh9BjzDwzN8Y
ce87hHUFrCC9WmdnUp2hVeL6FILxYKXnPQg4Hg5617/OF4ZVHMZrIDL8fFqS9UBf
3Ltk0EflLx8TscFlnh5A
=AB8M
-----END PGP SIGNATURE-----

--nextPart1644669.FN7hmrolrd--

