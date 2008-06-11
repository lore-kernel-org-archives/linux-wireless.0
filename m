Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:47621 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbYFKU75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 16:59:57 -0400
Message-ID: <48503CE4.1050100@lwfinger.net> (sfid-20080611_230000_503168_F3F67CCA)
Date: Wed, 11 Jun 2008 16:00:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
CC: Pavel Roskin <proski@gnu.org>, Michael Buesch <mb@bu3sch.de>,
	Tim Gardner <tim.gardner@canonical.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Open source driver with binary HAL for BCM4313 from Broadcom
References: <48500F14.8070300@canonical.com> <200806112047.00854.mb@bu3sch.de>	 <1213213666.19106.12.camel@dv> <69e28c910806111326j6922905fq1f67201ab4ce298f@mail.gmail.com>
In-Reply-To: <69e28c910806111326j6922905fq1f67201ab4ce298f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefanik G=E1bor wrote:
> On Wed, Jun 11, 2008 at 9:47 PM, Pavel Roskin <proski@gnu.org> wrote:
>> Instead, Broadcom tries to control the code its users are running.  =
I
>> don't think it's going to work well.  But to be fair to them, at lea=
st
>> they don't pretend that Linux doesn't exit.
>=20
> And that's quite an achievement...
> Anyway, what are the actual, working download links? The ones on the
> site just 404 out for me.

http://www.broadcom.com/docs/linux_sta/hybrid-portsrc-x86_64_5_10_18.ta=
r.gz

for the 64-bit version, and

http://www.broadcom.com/docs/linux_sta/hybrid-portsrc_5_10_18.tar.gz

for the 32-bit version. The binary blob is for x86 architecture only.=20
Other platforms are out of luck. They also have a README at

http://www.broadcom.com/docs/linux_sta/README.txt

As noted earlier, the BCM4310 has a PCI ID of 0x4315. I have one of=20
those cards and could test their blob pile. ATM, I'm using b43 on a=20
BCM4312 (a/b/g) card, but it has an ID of 0x4312.

I've only had a quick look at their code, but I don't think it will be=20
much help for the RE project. Most of the interesting stuff seems to=20
be in the binary blob.

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
