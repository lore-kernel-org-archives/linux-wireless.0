Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49820 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab3B1QKj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 11:10:39 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UB64Q-00027z-11
	for linux-wireless@vger.kernel.org; Thu, 28 Feb 2013 17:10:58 +0100
Received: from c-68-53-95-0.hsd1.tn.comcast.net ([68.53.95.0])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2013 17:10:58 +0100
Received: from aaraines by c-68-53-95-0.hsd1.tn.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2013 17:10:58 +0100
To: linux-wireless@vger.kernel.org
From: Drew Raines <aaraines@gmail.com>
Subject: Re: drivers/net/wireless/iwlwifi/dvm/tx.c and arch/x86/kernel/apic/ipi.c: Kernel trace when roaming between different Access Points with the same ESSID
Date: Thu, 28 Feb 2013 10:10:15 -0600
Message-ID: <874ngwfmhk.fsf@mid.raines.me> (sfid-20130228_171049_414825_8CA38DAB)
References: <CAD77+gQFfNvz02=0FWDq+KUGk5QO_MywWw=NBMk6YaFGNQ4+kA@mail.gmail.com>
	<CAD77+gTFDbNopgJjMv+BGJCbueR-k8Uiyq41DfOeF_t1oJm7EA@mail.gmail.com>
	<87d2vowff1.fsf@mid.raines.me> <87bob8cpls.fsf@mid.raines.me>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drew Raines wrote:

> As I was messing around with downgrading my kernel package (where'd
> 3.5-trunk go??) it occurred to me that I hadn't yet tried a more
> recent version of firmware-iwlwifi.  I had been on 0.36+wheezy.1.
> After installing 0.37 from experimental, this issue seems to have
> disappeared.

Apparently after a few hibernations and suspends the issue
resurfaces.  I move access points and my connection stop functioning
and eventually get this log message:

Feb 28 09:51:26 beta kernel: [105937.778241] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues

The only fix is a reset of the hardware radio switch on the side of
the laptop.

What can I do to diagnose further?

-Drew

