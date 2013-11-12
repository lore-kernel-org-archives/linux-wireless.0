Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mantis.wzyboy.im ([199.83.51.51]:39240 "EHLO mantis.wzyboy.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab3KLMZ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 07:25:57 -0500
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301DF044C@HASMSX103.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <CALkVjQZRJw7ghjBa1aPKNKe3Zj2B1Mhk5bWVaRdcCYzfoLRovg@mail.gmail.com>
 <CALkVjQY7r=YKhsgDKR0mnYVtZy5BAdj83nY2jL0VFaiew6ha7A@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
 <CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com>
 <527A8166.6000701@gmail.com> <CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
 <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
 <CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
 <CALkVjQYkAWrwRabQfBSvC1pm47ZyRT5jQ0mYBwbiGh-Bt29gbg@mail.gmail.com>
 <20131111224439.GA30638@google.com> <CALkVjQb-AJRSGARCQaDFkd+mHBk2qFkAVyVBTW7RHSaxzbZsbw@mail.gmail.com>
 <CALkVjQaXEBpbwu9Qy3+17Eg-nSg-k7iin8G3f1RsTLkCOB-2XQ@mail.gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB301DF044C@HASMSX103.ger.corp.intel.com>
From: wzyboy <wzyboy@wzyboy.org>
Date: Tue, 12 Nov 2013 20:25:40 +0800
Message-ID: <CALkVjQb9H73yjYHUhr6Lrsirr_eTT9JDpCCr-6o6qutL=b3S6A@mail.gmail.com> (sfid-20131112_132601_747961_06C853B7)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/11/12 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
> Well... I haven't done much, but the setpci isn't really a solution - it is more a work around.
> Bjorn is basically disabling L1 PCIe feature which allows to save power. While you might not care, I do :)
> The HW folks here would still want to know if you can disable L1 substates feature (not that I know what it is - but I can guess).
> If you can try to:
>  * upgrade your BIOS (if needed)
>  * check the advanced options I sent to you to see if you can unlock the advanced menu in your BIOS
>
> it'd help me to understand the issue.
> In any case, I am happy that you have a way to reliably use your NIC now.


Oh, actually I upgraded my BIOS to newest version the day I got this
laptop (12 days ago).

ThinkPad really changed a lot after being acquired by Lenovo...

As of ASU, I've downloaded it but I do not know how to show hidden
BIOS options with it since I have little knowledge about hardware...

Here is what I got when running ./asu64 dump:

wzyboy@xenien:~/Desktop/asu$ sudo ./asu64 dump
IBM Advanced Settings Utility version 9.41.81K
Licensed Materials - Property of IBM
(C) Copyright IBM Corp. 2007-2013 All Rights Reserved
     0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00: 00>00*00*00*00*00*67*8b*45*06*67*f6*45*ec*01*75
10: 03*b8*00*f0*8e*d8*67*8e*45*04*67*8b*7d*02*33*c0
20: 26*89*45*04*a1*61*09*26*89*45*02*a0*63*09*26*88
30: 45*01*26*c6*05*01*b8*00*00*c3*b8*82*00*c3*b8*82
40: 00*c3*b8*82*00*c3*b8*82*00*c3*b8*00*10*26*89*45
50: 0d*f8*c3*9c*66*60*e4*60*eb*00*eb*00*66*61*9d*c3
60: 1e*b8*40*00*8e*d8*f6*06*10*04*04*74*03*1f*f8*c3
70: 1f*f9*c3*f8*c3*25*00*00*41*d0*00*00*08*00*00*03
80: 00*22*04*00*47*01*20*00*20*00*00*02*47*01*a0*00
90: a0*00*00*02*79*00*79*00*79*00*45*00*00*41*d0*02
a0: 00*08*01*00*03*00*2a*10*00*47*01*00*00*00*00*00
b0: 10*47*01*81*00*81*00*00*03*47*01*87*00*87*00*00
c0: 01*47*01*89*00*89*00*00*03*47*01*8f*00*8f*00*00
d0: 03*47*01*c0*00*c0*00*00*20*79*00*79*00*79*00*1d
e0: 00*00*41*d0*01*00*08*02*01*03*00*22*01*00*47*01
f0: 40*00*40*00*00*04*79*00*79*00*79*00*1d*00*00*41


Could you help by telling me what command should I run to enable those
hidden options in BIOS?
-- 
wzyboy
