Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from defaultvalue.org ([70.85.129.156]:36294 "EHLO defaultvalue.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab1EPFSn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 01:18:43 -0400
From: Rob Browning <rlb@defaultvalue.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Slow receive with rtl8192cu (usb ew-7811Un)
References: <87pqnl5i81.fsf@raven.defaultvalue.org>
	<4DD074E3.3090502@lwfinger.net>
	<87vcxbe5xz.fsf@trouble.defaultvalue.org>
	<4DD09C78.2010304@lwfinger.net>
Date: Mon, 16 May 2011 00:18:41 -0500
In-Reply-To: <4DD09C78.2010304@lwfinger.net> (Larry Finger's message of "Sun,
	15 May 2011 22:39:36 -0500")
Message-ID: <8762pbkytq.fsf@trouble.defaultvalue.org> (sfid-20110516_071847_128815_CDA90A27)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> You could patch either the linux-2.6 kernel (2.6.39-rc7), the
> wireless-testing git tree, or get the source from your distro. You
> will have to build the entire kernel as I do not have the necessary
> make files to build the driver as an out of kernel module.

That patch didn't seem to have an effect -- the receive rate still
settles at about 60Kb/s.

I patched the Debian linux-2.6 source package and rebuilt the kernel.
The Debian kernel appeared to already have the wifi.h diff.

Please let me know if I can help further.

Thanks
-- 
Rob Browning
rlb @defaultvalue.org and @debian.org
GPG as of 2002-11-03 14DD 432F AE39 534D B592 F9A0 25C8 D377 8C7E 73A4
