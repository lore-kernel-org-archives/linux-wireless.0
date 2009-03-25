Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:34090
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbZCYC7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 22:59:48 -0400
Date: Wed, 25 Mar 2009 11:59:45 +0900
From: Mattia Dongili <malattia@linux.it>
To: Abhi Kolekar <kolekar.a@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	reinette.chatre@intel.com, yi.zhu@intel.com, linville@tuxdriver.com
Subject: Re: iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after
	500ms
Message-ID: <20090325025944.GA12447@kamineko.org> (sfid-20090325_035950_481315_90798AC8)
References: <20090321065006.GF3834@kamineko.org> <178fec830903211130x7aa2d266u5f249625c4436fd0@mail.gmail.com> <20090322011517.GA17905@kamineko.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20090322011517.GA17905@kamineko.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 22, 2009 at 10:15:17AM +0900, Mattia Dongili wrote:
> On Sat, Mar 21, 2009 at 11:30:29AM -0700, Abhi Kolekar wrote:
> > On Fri, Mar 20, 2009 at 11:50 PM, Mattia Dongili <malattia@linux.it=
> wrote:
> > > Hello,
> > >
> > > I get this error consistently with all the recent kernels:
> > > [ =A0338.476057] iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: t=
ime out after 500ms.
> > > [ =A0458.976089] iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: t=
ime out after 500ms.
> > > [ =A0598.885036] iwl3945: Microcode SW error detected. =A0Restart=
ing 0x82000008.
> > > [ =A0598.885050] iwl3945: Error Reply type 0x00000005 cmd REPLY_T=
X (0x1C) seq 0x02AC ser 0x0000004E
> > > [ =A0601.869319] iwl3945: Can't stop Rx DMA.
> > > then the wifi connection becomes useless and I have to re-associa=
te to
> > > the AP or sometimes to unload and reload the module to get my con=
nection
> > > back.
> > >
> > > The above is on 2.6.29-rc8 but I get it since 2.6.28 (apologies f=
or not

Actually since 2.6.27.

> > > reporting it earlier). =A0Both my thinkpad x60s and my vaio sz72b=
 are
> > > affected.
> > > Reproducing it is very easy, I just need to download even a small=
 file.
> > >
> > > After reading some older bug submissions I rebuilt the driver wit=
h debug
> > > support and loaded it with debug=3D0x43fff, the log is here:
> > > http://kamineko.org/kernel/kern.log
> > > The beginning of the log is 2.6.28 with no debug, then you can se=
e a
> > > reboot and the module loaded with the debug option on 2.6.29-rc8.
> > >
> > > Is this a known problem? Is there any other information I can pro=
vide to
> > > help fixing it?

Anyone?

--=20
mattia
:wq!
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
