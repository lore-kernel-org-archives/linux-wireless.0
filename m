Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:48049 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbZAXTy0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 14:54:26 -0500
Subject: [PATCH] CRDA 0.1.0: Fix building with --as-needed
From: Tony Vroon <tony@linx.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org,
	"Diego E. 'Flameeyes'" =?ISO-8859-1?Q?Petten=F2?=
	<flameeyes@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8BCXtn/+Uzb65HmkUEBT"
Date: Sat, 24 Jan 2009 19:54:55 +0000
Message-Id: <1232826895.19384.3.camel@localhost> (sfid-20090124_205448_220881_F4324ACF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8BCXtn/+Uzb65HmkUEBT
Content-Type: multipart/mixed; boundary="=-Sep8Oj/UBdOIYZv3q27X"


--=-Sep8Oj/UBdOIYZv3q27X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

It seems mails from Flameeyes just do not make it through to
linux-wireless, so there it is. Please apply this and consider releasing
1.0.1 (without a v in the tarball name, if at all possible).

Thanks,
Tony V.

--=-Sep8Oj/UBdOIYZv3q27X
Content-Disposition: inline
Content-Description: Forwarded message - [PATCH] Fix building with
 --as-needed.
Content-Type: message/rfc822

Return-Path: <flameeyes@gmail.com>
Received: from gold.linx.net (gold.linx.net [195.66.232.40]) by orange
 (Cyrus v2.3.13-Gentoo) with LMTPA; Sat, 24 Jan 2009 16:50:36 +0000
X-Sieve: CMU Sieve 2.3
Received: from localhost (localhost [127.0.0.1]) by gold.linx.net (Postfix)
 with ESMTP id 60AE010077 for <tony@linx.net>; Sat, 24 Jan 2009 16:50:36
 +0000 (GMT)
X-Virus-Scanned: amavisd-new at linx.net
X-Spam-Flag: NO
X-Spam-Score: 0
X-Spam-Level: 
X-Spam-Status: No, score=0 required=4.3 tests=[none]
Authentication-Results: gold.linx.net (amavisd-new); dkim=pass
 header.i=@gmail.com
Authentication-Results: gold.linx.net (amavisd-new); domainkeys=pass
 header.from=flameeyes@gmail.com
Received: from fg-out-1718.google.com (fg-out-1718.google.com
 [72.14.220.156]) by gold.linx.net (Postfix) with ESMTP id E29751005D for
 <tony@linx.net>; Sat, 24 Jan 2009 16:50:34 +0000 (GMT)
Received: by fg-out-1718.google.com with SMTP id e21so2775729fga.37 for
 <tony@linx.net>; Sat, 24 Jan 2009 08:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
 h=domainkey-signature:received:received:from:to:cc:subject:date
 :message-id:x-mailer:mime-version:content-type :content-transfer-encoding;
 bh=S5f3R2a+Jh9YCA5e59UySOaNZIo7ulayVqBBYFLvxZI=;
 b=VLB+mhmNje9TWgOvgAdQhnI/CoYUpkOdsopz67itIYWhMAExq+Je7zLP84zuT075Qr
 VssjNf/gjLLaW4pUGTSrfL/v1a+5d5hsqnEqUaKDmbZgWZuCOYrdlmgotyyQgIOiUFKz
 jXJoOrYx6UIe/jz+Jdx2aiTiEtfXVy2GIVAfI=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=gmail.com; s=gamma;
 h=from:to:cc:subject:date:message-id:x-mailer:mime-version
 :content-type:content-transfer-encoding;
 b=gBZdmgbDCLN6UkrIiEfUvd9ecXuD/3gEzA6/oW/T6NeeYMeaozYJIlQldiKoCxF7lf
 qsAZbeyc0/kh26TUGWRtLzxHY1gP7nwcgd+vfgjt7h2RxPwAQe6JydyMiXjmcYw9B+ZK
 o3B/jU3OM8AhDwkEgx/Fa+ez1QdhEjE/SubiM=
Received: by 10.86.100.19 with SMTP id x19mr111892fgb.29.1232815834057;
 Sat, 24 Jan 2009 08:50:34 -0800 (PST)
Received: from yamato (ppp-196-234.21-151.libero.it [151.21.234.196]) by
 mx.google.com with ESMTPS id d4sm2123531fga.51.2009.01.24.08.50.32
 (version=TLSv1/SSLv3 cipher=RC4-MD5); Sat, 24 Jan 2009 08:50:32 -0800 (PST)
From: =?utf-8?q?Diego=20Elio=20=27Flameeyes=27=20Petten=C3=B2?= <flameeyes@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Tony Vroon <tony@linx.net>, =?utf-8?q?Diego=20E.=20'Flameeyes'=20Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [PATCH] Fix building with --as-needed.
Date: Sat, 24 Jan 2009 17:50:31 +0100
Message-Id: <1232815831-6437-1-git-send-email-flameeyes@gmail.com>
X-Mailer: git-send-email 1.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

From: Diego E. 'Flameeyes' Petten=C3=B2 <flameeyes@gmail.com>

For --as-needed to work (and for traditional ld too) the libraries should
always be passed _after_ the object files, move them so that they are
picked up properly.

Also rename LIBS to NLLIBS to avoid confusion between LIBS/LDLIBS.
---
 Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index a07fbcf..aaa9ca6 100644
--- a/Makefile
+++ b/Makefile
@@ -48,11 +48,11 @@ endif
=20
 ifeq ($(NL2FOUND),Y)
 CFLAGS +=3D -DCONFIG_LIBNL20
-LIBS +=3D -lnl-genl
+NLLIBS +=3D -lnl-genl
 NLLIBNAME =3D libnl-2.0
 endif
=20
-LIBS +=3D `pkg-config --libs $(NLLIBNAME)`
+NLLIBS +=3D `pkg-config --libs $(NLLIBNAME)`
 CFLAGS +=3D `pkg-config --cflags $(NLLIBNAME)`
=20
 ifeq ($(V),1)
@@ -85,7 +85,7 @@ keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem=
)
=20
 crda: reglib.o crda.o
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(LIBS) -o $@ $^ $(LDLIBS)
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS) $(NLLIBS)
=20
 regdbdump: reglib.o regdbdump.o print-regdom.o
 	$(NQ) '  LD  ' $@
--=20
1.6.1


--=-Sep8Oj/UBdOIYZv3q27X--

--=-8BCXtn/+Uzb65HmkUEBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkl7cg8ACgkQp5vW4rUFj5oADACcD8tUR/eon9AVkC41dUfvAJ8p
uRMAoKG3pSSZvrUFxPhhEmiR9eI0SrNc
=iKYe
-----END PGP SIGNATURE-----

--=-8BCXtn/+Uzb65HmkUEBT--

