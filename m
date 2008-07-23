Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.Stanford.EDU ([171.67.22.28]:49164 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbYGWUdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 16:33:17 -0400
Received: from smtp1.stanford.edu (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 461DA27243D
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 13:33:16 -0700 (PDT)
Received: from localhost (Gautam.Stanford.EDU [171.64.38.214])
	by smtp1.stanford.edu (Postfix) with ESMTP id 0ED8827234B
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 13:33:15 -0700 (PDT)
Date: Wed, 23 Jul 2008 13:32:49 -0700
From: Gautam Iyer <gi1242+vger@stanford.edu>
To: linux-wireless@vger.kernel.org
Subject: Re: 2.6.26 b43 speed issue (redux) and new firmware drivers
Message-ID: <20080723203249.GB23882@stanford.edu> (sfid-20080723_223320_589982_3D824ACB)
References: <20080722193637.GC19885@stanford.edu> <48874C9D.2050900@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
In-Reply-To: <48874C9D.2050900@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2008 at 10:22:05AM -0500, Larry Finger wrote:

>> I'm writing to inquire about a "new" firmware drivers for Broadcom 43xx:
>> On April 6, 2008 it looks like broadcom-wl-4.150.10.5.2.tar.bz2 appeared
>> on http://mirror2.openwrt.org/sources/. The install guide for b43
>> recommends you use b43-fwcutter-011 and broadcom-wl-4.150.10.5.tar.bz2
>> I tried to use broadcom-wl-4.150.10.5.2.tar.bz2 with b43-fwcutter-011,
>> but it complained that the md5 sum was not recognized :). Just wondering
>> if there is any way to use this new firmware?
>> Thanks in advance,
>> GI
>> PS: The main reason I ask is for "performance": A while ago I reported
>>     that my Broadcom 4312 gave 2/3 the speed under b43 (2.6.25), when
>>     compared to ndiswrapper. (I tested by running ttcp, and measuring
>>     the throughput. I got roughly 3MB/s with ndiswrapper, and
>>     2 MB/s with b43).
>>     I just upgraded to 2.6.26, and found that my b43 speed *increased*
>>     to 2.4MB/s :). So thanks to whomever is responsible! I was also
>>     hoping that if I upgrade even the firmware I would be able to
>>     "toast" ndiswrapper. (I transfer large files on my home network
>>     often, which is why I care about the speed so much.)
>
> I do not know what changed between 4.150.10.5 and 4.150.10.2, but I
> doubt that the firmware in the new driver will make any appreciable
> difference in the performance of the BCM4312. My guess is that they
> found some errors in the handling of the N PHY or the LP PHY, which
> are the two newest devices, and fixed them. Of course, we do need to
> update fwcutter to test my hypothesis. As a reverse engineer, I also
> need to see what changed. What version is the Windows driver that you
> use?

Hi Larry,

Thanks for the response. The windows driver I used can be found at

    http://h20000.www2.hp.com/bizsupport/TechSupport/SoftwareDescription.js=
p?lang=3Den&cc=3Dus&prodTypeId=3D321957&prodSeriesId=3D3355644&prodNameId=
=3D3355645&swEnvOID=3D1059&swLang=3D8&mode=3D2&taskId=3D135&swItem=3Dob-557=
03-1

It looks like HP released a few newer versions of this driver, which I
haven't tested yet. I use the b43 drivers all the time anyway.

> It is a fact of life that this kind of reverse engineering rarely will
> perform better than the original driver. After all, if we make an
> exact copy, then we repeat their mistakes. Any mistakes of ours have a
> small chance of improving performance. Where we do improve on the
> original is in the error handling.

Time to fire up the petition to get Broadcom to open up their specs for
Linux devs...

Hopefully the new firmware 4.150.10.2 helps with b43 somehow.
Nevertheless, thanks for all you guys have done with the b43 driver!! It
really is wonderful!

GI

--=20
Linux for Network, Mac for Work, Windows for Solitaire

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiHlXEACgkQ6plSLtsExHGRrgCgi5CAI0y1FSMX8Jpzjv9bFebC
FsYAnj/am34MpTRMBCGOMUWhLpelRPIA
=JMRH
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
