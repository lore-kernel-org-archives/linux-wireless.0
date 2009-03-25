Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:63614 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758055AbZCYFVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 01:21:44 -0400
MIME-Version: 1.0
In-Reply-To: <20090325025944.GA12447@kamineko.org>
References: <20090321065006.GF3834@kamineko.org>
	 <178fec830903211130x7aa2d266u5f249625c4436fd0@mail.gmail.com>
	 <20090322011517.GA17905@kamineko.org>
	 <20090325025944.GA12447@kamineko.org>
Date: Tue, 24 Mar 2009 22:21:41 -0700
Message-ID: <178fec830903242221l6c07f8a1k8c91be94bc70fc37@mail.gmail.com> (sfid-20090325_062150_063788_F8AD7658)
Subject: Re: iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after
	500ms
From: Abhi Kolekar <kolekar.a@gmail.com>
To: Mattia Dongili <malattia@linux.it>
Cc: linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	reinette.chatre@intel.com, yi.zhu@intel.com, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can you create a bug at http://www.intellinuxwireless.org/bugzilla/ ?

Thanks
Abhijeet

On Tue, Mar 24, 2009 at 7:59 PM, Mattia Dongili <malattia@linux.it> wro=
te:
> On Sun, Mar 22, 2009 at 10:15:17AM +0900, Mattia Dongili wrote:
>> On Sat, Mar 21, 2009 at 11:30:29AM -0700, Abhi Kolekar wrote:
>> > On Fri, Mar 20, 2009 at 11:50 PM, Mattia Dongili <malattia@linux.i=
t> wrote:
>> > > Hello,
>> > >
>> > > I get this error consistently with all the recent kernels:
>> > > [ =A0338.476057] iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: =
time out after 500ms.
>> > > [ =A0458.976089] iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: =
time out after 500ms.
>> > > [ =A0598.885036] iwl3945: Microcode SW error detected. =A0Restar=
ting 0x82000008.
>> > > [ =A0598.885050] iwl3945: Error Reply type 0x00000005 cmd REPLY_=
TX (0x1C) seq 0x02AC ser 0x0000004E
>> > > [ =A0601.869319] iwl3945: Can't stop Rx DMA.
>> > > then the wifi connection becomes useless and I have to re-associ=
ate to
>> > > the AP or sometimes to unload and reload the module to get my co=
nnection
>> > > back.
>> > >
>> > > The above is on 2.6.29-rc8 but I get it since 2.6.28 (apologies =
for not
>
> Actually since 2.6.27.
>
>> > > reporting it earlier). =A0Both my thinkpad x60s and my vaio sz72=
b are
>> > > affected.
>> > > Reproducing it is very easy, I just need to download even a smal=
l file.
>> > >
>> > > After reading some older bug submissions I rebuilt the driver wi=
th debug
>> > > support and loaded it with debug=3D0x43fff, the log is here:
>> > > http://kamineko.org/kernel/kern.log
>> > > The beginning of the log is 2.6.28 with no debug, then you can s=
ee a
>> > > reboot and the module loaded with the debug option on 2.6.29-rc8=
=2E
>> > >
>> > > Is this a known problem? Is there any other information I can pr=
ovide to
>> > > help fixing it?
>
> Anyone?
>
> --
> mattia
> :wq!
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
