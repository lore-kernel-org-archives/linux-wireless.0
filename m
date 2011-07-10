Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from defaultvalue.org ([70.85.129.156]:59342 "EHLO defaultvalue.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab1GJUY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2011 16:24:29 -0400
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
	<874o45z6b8.fsf@raven.defaultvalue.org>
	<874o41rqrg.fsf@trouble.defaultvalue.org>
	<87oc222acu.fsf@raven.defaultvalue.org>
Date: Sun, 10 Jul 2011 15:24:27 -0500
In-Reply-To: <87oc222acu.fsf@raven.defaultvalue.org> (Rob Browning's message
	of "Sun, 12 Jun 2011 13:06:08 -0500")
Message-ID: <87aacl6g04.fsf@raven.defaultvalue.org> (sfid-20110710_222433_531175_F85E36B5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rob Browning <rlb@defaultvalue.org> writes:

> Instead, I was able to test an ath9k_htc based adapter (netgear n150),
> which doesn't appear to have trouble in the same environment, but I'd
> still prefer to use the much smaller rtl8192cu device if we can figure
> out what's wrong.

Actually, I just realized I quoted the wrong model number above.  The
device that works well is the WNA1100.

The rtl8192cu devices still struggle, after a short initial period of
reasonable behavior.

Thanks
-- 
Rob Browning
rlb @defaultvalue.org and @debian.org
GPG as of 2002-11-03 14DD 432F AE39 534D B592 F9A0 25C8 D377 8C7E 73A4
