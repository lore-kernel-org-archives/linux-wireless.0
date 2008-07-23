Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.Stanford.EDU ([171.67.20.26]:49995 "EHLO
	smtp3.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYGWUru (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 16:47:50 -0400
Received: from smtp3.stanford.edu (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 1A62260EBC2
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 13:40:34 -0700 (PDT)
Received: from localhost (Gautam.Stanford.EDU [171.64.38.214])
	by smtp3.stanford.edu (Postfix) with ESMTP id DC56560EC09
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 13:40:33 -0700 (PDT)
Date: Wed, 23 Jul 2008 13:40:07 -0700
From: Gautam Iyer <gi1242+vger@stanford.edu>
To: linux-wireless@vger.kernel.org
Subject: Re: 2.6.26 b43 speed issue (redux) and new firmware drivers
Message-ID: <20080723204007.GC23882@stanford.edu> (sfid-20080723_224753_413747_3DCD2B5B)
References: <20080722193637.GC19885@stanford.edu> <48874C9D.2050900@lwfinger.net> <20080723203249.GB23882@stanford.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HG+GLK89HZ1zG0kk"
In-Reply-To: <20080723203249.GB23882@stanford.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--HG+GLK89HZ1zG0kk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2008 at 01:32:49PM -0700, Gautam Iyer wrote:

>>> I'm writing to inquire about a "new" firmware drivers for Broadcom 43xx:
>>> On April 6, 2008 it looks like broadcom-wl-4.150.10.5.2.tar.bz2 appeared
>>> on http://mirror2.openwrt.org/sources/. The install guide for b43
>>> recommends you use b43-fwcutter-011 and broadcom-wl-4.150.10.5.tar.bz2
>>> I tried to use broadcom-wl-4.150.10.5.2.tar.bz2 with b43-fwcutter-011,
>>> but it complained that the md5 sum was not recognized :). Just wondering
>>> if there is any way to use this new firmware?
>>> Thanks in advance,
>>> GI
>>> PS: The main reason I ask is for "performance": A while ago I reported
>>>     that my Broadcom 4312 gave 2/3 the speed under b43 (2.6.25), when
>>>     compared to ndiswrapper. (I tested by running ttcp, and measuring
>>>     the throughput. I got roughly 3MB/s with ndiswrapper, and
>>>     2 MB/s with b43).
>>>     I just upgraded to 2.6.26, and found that my b43 speed *increased*
>>>     to 2.4MB/s :). So thanks to whomever is responsible! I was also
>>>     hoping that if I upgrade even the firmware I would be able to
>>>     "toast" ndiswrapper. (I transfer large files on my home network
>>>     often, which is why I care about the speed so much.)
>>
>> I do not know what changed between 4.150.10.5 and 4.150.10.2, but I
>> doubt that the firmware in the new driver will make any appreciable
>> difference in the performance of the BCM4312. My guess is that they
>> found some errors in the handling of the N PHY or the LP PHY, which
>> are the two newest devices, and fixed them. Of course, we do need to
>> update fwcutter to test my hypothesis. As a reverse engineer, I also
>> need to see what changed. What version is the Windows driver that you
>> use?
>=20
> Hi Larry,
>=20
> Thanks for the response. The windows driver I used can be found at
>=20
>     http://h20000.www2.hp.com/bizsupport/TechSupport/SoftwareDescription.=
jsp?lang=3Den&cc=3Dus&prodTypeId=3D321957&prodSeriesId=3D3355644&prodNameId=
=3D3355645&swEnvOID=3D1059&swLang=3D8&mode=3D2&taskId=3D135&swItem=3Dob-557=
03-1
>=20
> It looks like HP released a few newer versions of this driver, which I
> haven't tested yet. I use the b43 drivers all the time anyway.

If it makes any difference -- clicking on the enhancements tab in the
above link says that this driver provides broadcoms 4.170.25.12...

GI

--=20
Bakers trade bread recipes on a knead-to-know basis.

--HG+GLK89HZ1zG0kk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiHlycACgkQ6plSLtsExHF0PwCfaKuCm2YyvyqykpdLbJS2O4ou
tfsAoKdDCgzZ6Jol1UKv/UtjVA+qa9Fg
=GRMl
-----END PGP SIGNATURE-----

--HG+GLK89HZ1zG0kk--
