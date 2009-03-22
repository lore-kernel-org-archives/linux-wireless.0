Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:45767
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZCVBPU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 21:15:20 -0400
Date: Sun, 22 Mar 2009 10:15:17 +0900
From: Mattia Dongili <malattia@linux.it>
To: Abhi Kolekar <kolekar.a@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	reinette.chatre@intel.com, yi.zhu@intel.com, linville@tuxdriver.com
Subject: Re: iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after
	500ms
Message-ID: <20090322011517.GA17905@kamineko.org> (sfid-20090322_021524_386037_53EA2402)
References: <20090321065006.GF3834@kamineko.org> <178fec830903211130x7aa2d266u5f249625c4436fd0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <178fec830903211130x7aa2d266u5f249625c4436fd0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 21, 2009 at 11:30:29AM -0700, Abhi Kolekar wrote:
> On Fri, Mar 20, 2009 at 11:50 PM, Mattia Dongili <malattia@linux.it> =
wrote:
> > Hello,
> >
> > I get this error consistently with all the recent kernels:
> > [ =A0338.476057] iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: tim=
e out after 500ms.
> > [ =A0458.976089] iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: tim=
e out after 500ms.
> > [ =A0598.885036] iwl3945: Microcode SW error detected. =A0Restartin=
g 0x82000008.
> > [ =A0598.885050] iwl3945: Error Reply type 0x00000005 cmd REPLY_TX =
(0x1C) seq 0x02AC ser 0x0000004E
> > [ =A0601.869319] iwl3945: Can't stop Rx DMA.
> > then the wifi connection becomes useless and I have to re-associate=
 to
> > the AP or sometimes to unload and reload the module to get my conne=
ction
> > back.
> >
> > The above is on 2.6.29-rc8 but I get it since 2.6.28 (apologies for=
 not
> > reporting it earlier). =A0Both my thinkpad x60s and my vaio sz72b a=
re
> > affected.
> > Reproducing it is very easy, I just need to download even a small f=
ile.
> >
> > After reading some older bug submissions I rebuilt the driver with =
debug
> > support and loaded it with debug=3D0x43fff, the log is here:
> > http://kamineko.org/kernel/kern.log
> > The beginning of the log is 2.6.28 with no debug, then you can see =
a
> > reboot and the module loaded with the debug option on 2.6.29-rc8.
> >
> > Is this a known problem? Is there any other information I can provi=
de to
> > help fixing it?
>=20
> Hello Mattia,
>    Do you have 64 bit kernel?

No, both laptops  are running 32bit kernels

--=20
mattia
:wq!
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
