Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from defaultvalue.org ([70.85.129.156]:41817 "EHLO defaultvalue.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab1EQD5K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 23:57:10 -0400
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
Date: Mon, 16 May 2011 22:57:08 -0500
In-Reply-To: <87iptaj8nf.fsf@trouble.defaultvalue.org> (Rob Browning's message
	of "Mon, 16 May 2011 22:41:40 -0500")
Message-ID: <87fwoehtd7.fsf@trouble.defaultvalue.org> (sfid-20110517_055714_017875_0148898B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rob Browning <rlb@defaultvalue.org> writes:

> So that command ran at essentially the rates you report for 10-20
> seconds.  Then I killed it and tried another test I'd been using, which
> was to lftp to ftp.kernel.org and get -c linux-2.6.39-rc7.tar.bz2.  That
> transfer started at a high rate, but settled fairly quickly at about
> 60KB/s.  So I killed that transfer and restarted the wget, and it ran
> steadily at ~60KB/s.

In case it helps, it also looks like the 60KB/s is an aggregate limit.
Once it gets into the "lower bandwidth" state, if I run multiple
transfers, the total won't go above that.

-- 
Rob Browning
rlb @defaultvalue.org and @debian.org
GPG as of 2002-11-03 14DD 432F AE39 534D B592 F9A0 25C8 D377 8C7E 73A4
