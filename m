Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:59260 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776Ab1JaNKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 09:10:13 -0400
Received: by mail-bw0-f47.google.com with SMTP id zv3so2101599bkb.6
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 06:10:11 -0700 (PDT)
Subject: Re: wl1251 and NoA protocol
From: Luciano Coelho <coelho@ti.com>
To: =?ISO-8859-1?Q?Andr=E9s_Garc=EDa?= Saavedra
	<andres.garcia.saavedra@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CADxqDgEvsObWbnPTViPF5g_TOS2WRJoJK4OnEzehbdQwwgzNDQ@mail.gmail.com>
References: <CADxqDgEvsObWbnPTViPF5g_TOS2WRJoJK4OnEzehbdQwwgzNDQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Oct 2011 15:10:08 +0200
Message-ID: <1320066608.2672.15.camel@cumari> (sfid-20111031_141018_105872_3C09CB47)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-18 at 11:13 +0200, Andrés García Saavedra wrote: 
> Hi all,
> 
> I would like to test Notice of Absence powersaving protocol for
> 802.11abg WLANs on some current android smartphone. My question is
> regarding the wl1251 driver implementation for TI chipsets:
> 
> * Does the chipset/current implementation support sleep/awake
> triggers? (or at least quiet elements?) -> This means, can I command
> the NIC to stay quiet (slept) for certain duration of time?
> 
> My plan is to implement/test a Notice of Absence protocol where the
> driver would trigger absent (quiet/sleep) periods according to the
> beacon's NoA IE. Ive seen in the code the wl1251_ps_elp_sleep/wakeup
> functions that might be reused for this purpose (?)
> 
> * Last (lazy) question. AFAIK only the google dev 1 phone uses this
> chipset. Is there any 1ghz android device that could benefit of this
> driver?

You should look for a device with some newer chip, like the wl1271, for
instance.  We are currently developing the wl12xx driver (for wl127x and
wl128x) a lot more actively than wl1251.  Besides, I don't think there's
any newer Android phone using wl1251...


-- 
Cheers,
Luca.

