Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from defaultvalue.org ([70.85.129.156]:57978 "EHLO defaultvalue.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab1FLSGK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2011 14:06:10 -0400
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
Date: Sun, 12 Jun 2011 13:06:08 -0500
In-Reply-To: <874o41rqrg.fsf@trouble.defaultvalue.org> (Rob Browning's message
	of "Tue, 07 Jun 2011 21:38:59 -0500")
Message-ID: <87oc222acu.fsf@raven.defaultvalue.org> (sfid-20110612_200615_217100_D2325024)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rob Browning <rlb@defaultvalue.org> writes:

> Next I'll try a different access point -- I'll let you know what I find.
> And if there's anything else I can do to help test, please let me know.

Instead, I was able to test an ath9k_htc based adapter (netgear n150),
which doesn't appear to have trouble in the same environment, but I'd
still prefer to use the much smaller rtl8192cu device if we can figure
out what's wrong.

Thanks
-- 
Rob Browning
rlb @defaultvalue.org and @debian.org
GPG as of 2002-11-03 14DD 432F AE39 534D B592 F9A0 25C8 D377 8C7E 73A4
