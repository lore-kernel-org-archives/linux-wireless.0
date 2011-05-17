Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from defaultvalue.org ([70.85.129.156]:49392 "EHLO defaultvalue.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507Ab1EQXER (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 19:04:17 -0400
From: Rob Browning <rlb@defaultvalue.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Slow receive with rtl8192cu (usb ew-7811Un)
References: <87pqnl5i81.fsf@raven.defaultvalue.org>
	<4DD074E3.3090502@lwfinger.net>
	<87vcxbe5xz.fsf@trouble.defaultvalue.org>
	<4DD09C78.2010304@lwfinger.net>
	<8762pbkytq.fsf@trouble.defaultvalue.org>
	<4DD13EF0.2070803@lwfinger.net>
	<87iptaj8nf.fsf@trouble.defaultvalue.org>
	<87fwoehtd7.fsf@trouble.defaultvalue.org>
	<4DD2A3A9.90003@lwfinger.net>
Date: Tue, 17 May 2011 18:04:16 -0500
In-Reply-To: <4DD2A3A9.90003@lwfinger.net> (Larry Finger's message of "Tue, 17
	May 2011 11:34:49 -0500")
Message-ID: <87pqnhj5e7.fsf@raven.defaultvalue.org> (sfid-20110518_010427_606602_B4A858A2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> I can duplicate your result. To me, it appears to be a problem with
> bufferbloat. If that is correct, then there is little I can do with
> rtl8192cu to fix the problem. I see exactly the same slow rate with
> rt2800usb using an Ralink RT3070 device. In addition, I see that rate
> when connected to my router with a wired 100 Mbps connection.

I suppose that's possible, but I get much higher rates (300K/s+) when
connecting to the same AP using the built-in wireless chipset (BCM4322)
from another, very similar laptop, and 6.0Mbps when testing from a third
client.

I also get 800K/s+ when running the wget command you suggested over a
wired connection to my primary router.

Unfortunately, can't double-check the second laptop's wireless rate
right now, but it got 300K/s+ for a long time, and I just tested the
6Mbps client.  It was only when I migrated to the newer laptop and the
rtl8192cu usb adapter that I saw the much slower ~60K/s rate.

Thanks again
-- 
Rob Browning
rlb @defaultvalue.org and @debian.org
GPG as of 2002-11-03 14DD 432F AE39 534D B592 F9A0 25C8 D377 8C7E 73A4
