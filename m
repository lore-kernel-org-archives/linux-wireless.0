Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:33681 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756166AbcIYUQr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Sep 2016 16:16:47 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: "Pedersen, Thomas" <twp@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k mesh + ap + encryption?
Date: Sun, 25 Sep 2016 22:16:43 +0200
Message-ID: <3338244.IC8yTOzn2x@prime> (sfid-20160925_222021_698682_F0CB296D)
In-Reply-To: <1474669037.16013.9.camel@qca.qualcomm.com>
References: <2661831.slnB0LOeVt@prime> <5898628.mmcCycDigQ@prime> <1474669037.16013.9.camel@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6861210.EaRmynagmX"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6861210.EaRmynagmX
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday, September 23, 2016 10:18:49 PM CEST Pedersen, Thomas wrote:
> On Mon, 2016-09-19 at 08:43 +0200, Simon Wunderlich wrote:
> 
> > On Tuesday, September 13, 2016 5:54:38 PM CEST Pedersen, Thomas wrote:
> > 
> > > On Tue, 2016-09-13 at 14:30 +0200, Simon Wunderlich wrote:
> > > 
> > > 
> > > > [...]
> > > >
> > > >
> > > >
> > > > Thanks for the clarification. We will then stick to the 70's branch
> > > > then.
> > > > 
> > > > Does anyone have pointers for the other questions? :) I would believe
> > > > hat many 
> > > > people would be interested in running AP + Mesh encrypted at the same
> > > > time (at 
> > > > least in the open source community ...).
> > > 
> > > 
> > > 
> > > We're testing encrypted AP + Mesh quite successfully right now with
> > > this firmware: https://github.com/kvalo/ath10k-firmware/commit/307cb46b
> > > 06661ebd3186723b5002de769c7add83, of course that is for a QCA4019 chip.
> > > Which chip are you using? I can poke the firmware guys for possibility
> > > of getting a 10.4.3.2 firmware build for it.
> > 
> > 
> > Hi Thomas,
> > 
> > thanks for the hint! We are using an older QCA9882. I assume your firmware
> > will 
 not work for this one? If you can poke the firmware guys, that
> > would be great.> 
> > :)
> 
> 
> Hi Simon,
> 
> According to firmware guys the latest code can actually compile down to
> any chipset, so it should simply be a matter of getting builds released.

Hi Thomas,

thats great news, thanks for the heads up!

How are we going to get those builds released? Who can I ask, or do you want 
to take care of that?

Thanks,
     Simon
--nextPart6861210.EaRmynagmX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJX6DCrAAoJEKEr45hCkp6hA1sQALmhd+u6Wepu0P5TDiZ67b3p
GKe6IYuPKuvnb2B6eZEyvSjm/s6xLEnGkddb/jMJd9lppfDlmtGR+vj7J/CBAkKo
QHKvXZHtSmTdibf2flGowRt+OdESf+f/ijyyCLU2dcxlPZW1t1Ons64BrA+RYeZI
8RdNG/3Me3lH14Uw7LpcY8gndKIHPiiRbIAyf7mE+f2QCSxc0pYv8tpccsyDW2fA
6HNvzVgzjLis+tqzKqxo1WVGFis/EJELXYUqqvLKZ4La9aPLwQrg/dnMZD9u/eQ6
5QyCPYIN8zGCa2dv8Ddu2cVm4Wy6G8pd3gQLk5PCbkDh8PU9+U/BBhF4sz5aA+PK
7ljemnlNMZPUh5DNSnkYBDU0hNFT2qe0NljDBH/nvkr0q7d3+uZZ6qmZKXA3j7cN
kOSlX5xPCXmRBTx0d2BuxdWITeKfBpK79RQ+A8kffEyWtY4U93rPKXBcMrKtf1Oz
sIlezZnP3cKI/99gMX+P0bsKgK4vDgYYdYGT4ZZ7AcbQt+rgIpT0UcUsMfssBAYG
/EAIlEnCOuVxdUciNYjD64JzIn2W/EOdyz/RAJuy7XpOehyM/7qe9wbV+YkmcuJZ
AINofdY5FZc6oUbL7pfhS+jLzb57fx1e41ytN9ySIrrrT0/3w6trHRM1B8zbzbe1
60rMjhGSNM1HTJdnCbFY
=5SPc
-----END PGP SIGNATURE-----

--nextPart6861210.EaRmynagmX--
