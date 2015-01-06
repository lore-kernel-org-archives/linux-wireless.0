Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep17.mx.upcmail.net ([62.179.121.37]:32989 "EHLO
	fep17.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbbAFKjA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 05:39:00 -0500
Received: from edge03.upcmail.net ([192.168.13.238])
          by viefep17-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20150106103857.NYDY20864.viefep17-int.chello.at@edge03.upcmail.net>
          for <linux-wireless@vger.kernel.org>;
          Tue, 6 Jan 2015 11:38:57 +0100
Received: from [194.124.158.2] (jupiter.think.ch [194.124.158.2])
	(authenticated bits=0)
	by luna.think.ch (8.14.3/8.14.3) with ESMTP id t06ActM4026929
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 6 Jan 2015 11:38:56 +0100
Message-ID: <54ABBB43.1000803@think.ch> (sfid-20150106_113912_877076_CA210B8C)
Date: Tue, 06 Jan 2015 11:38:59 +0100
From: Erich Titl <erich.titl@think.ch>
MIME-Version: 1.0
CC: linux-wireless@vger.kernel.org
Subject: Re: b43 driver and WEP (solved)
References: <54AA5438.9070902@think.ch> <54AAFFB1.8030109@lwfinger.net>	 <54AB2405.3050602@think.ch> <54AB31EB.6020801@lwfinger.net>	 (sfid-20150106_015306_425223_200E98E0) <1420532972.1966.4.camel@sipsolutions.net>
In-Reply-To: <1420532972.1966.4.camel@sipsolutions.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050608040807060905070706"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050608040807060905070706
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 06.01.2015 um 09:29 schrieb Johannes Berg:
> On Mon, 2015-01-05 at 18:52 -0600, Larry Finger wrote:
>=20
>> Glad you found it. Strange that loading mac80211 did not force loading=
=2E Have you=20
>> run 'depmod -a' on the modules?
>=20
> I believe that mac80211 doesn't have a strong dependency on the module =
-
> it just loads the crypto algorithm at runtime.

Looking at the code that's exactly it.

Erich




--------------ms050608040807060905070706
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ccLeqQY9BgWnv7+dAAAAAAAA
--------------ms050608040807060905070706--
