Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64743 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZDYPf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 11:35:56 -0400
Received: by fxm2 with SMTP id 2so1563645fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 25 Apr 2009 08:35:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200904251650.17142.mb@bu3sch.de>
References: <200904251650.17142.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 25 Apr 2009 17:35:39 +0200
Message-ID: <69e28c910904250835q4eed1a3if06b0fe214e9801c@mail.gmail.com> (sfid-20090425_173600_184173_0C38D3BA)
Subject: Re: Warning in tx.c:775 invoke_tx_handlers
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 25, 2009 at 4:50 PM, Michael Buesch <mb@bu3sch.de> wrote:
> I just noticed the following warning on my test-AP:
>
> [973533.018255] ------------[ cut here ]------------
> [973533.018287] WARNING: at /home/mb/kernel/compat-wireless-2009-04-2=
0/net/mac80211/tx.c:775 invoke_tx_handlers+0xde4/0xe10 [mac80211]()
> [973533.018333] Hardware name:
> [973533.018354] Modules linked in: b43 ssb mac80211 cfg80211 [last un=
loaded: cfg80211]
> [973533.018408] Pid: 2825, comm: lighttpd Not tainted 2.6.29.1 #1
> [973533.018432] Call Trace:
> [973533.018452] =A0<IRQ> =A0[<ffffffff80244470>] warn_slowpath+0xd0/0=
x130
> [973533.018504] =A0[<ffffffffa00153a6>] ? op32_fill_descriptor+0x46/0=
xd0 [b43]
> [973533.018542] =A0[<ffffffffa0042913>] ? ssb_pci_write32+0x33/0x60 [=
ssb]
> [973533.018573] =A0[<ffffffff802130a0>] ? nommu_map_single+0x0/0xa0
> [973533.018608] =A0[<ffffffffa00150ed>] ? b43_dma_tx+0x54d/0x7c0 [b43=
]
> [973533.018652] =A0[<ffffffffa0042974>] ? ssb_pci_write16+0x34/0x60 [=
ssb]
> [973533.018689] =A0[<ffffffffa0017a05>] ? b43_led_turn_off+0x75/0xa0 =
[b43]
> [973533.018725] =A0[<ffffffffa0017b9d>] ? b43_led_brightness_set+0x3d=
/0x70 [b43]
> [973533.018767] =A0[<ffffffffa00e0a94>] invoke_tx_handlers+0xde4/0xe1=
0 [mac80211]
> [973533.018808] =A0[<ffffffffa00e11f3>] ? __ieee80211_tx+0x73/0xf0 [m=
ac80211]
>
> --
> Greetings, Michael.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

=46ragmented A-MPDU?

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
