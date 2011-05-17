Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from defaultvalue.org ([70.85.129.156]:55530 "EHLO defaultvalue.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab1EQDlm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 23:41:42 -0400
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
Date: Mon, 16 May 2011 22:41:40 -0500
In-Reply-To: <4DD13EF0.2070803@lwfinger.net> (Larry Finger's message of "Mon,
	16 May 2011 10:12:48 -0500")
Message-ID: <87iptaj8nf.fsf@trouble.defaultvalue.org> (sfid-20110517_054153_534809_F5EB19C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> Strange. With that patch in my system running with the current
> wireless-testing kernel, I get 19.8 Mbps download and 17.3 Mbps upload
> using tcpperf. The box at the other end is wired to my router/AP. The
> wireless connection is configured for 270 Mbps, thus rtl8192cu is not
> driving it at full rates, but that performance should be satisfactory.
>
> Please run the following command for a couple of minutes to see what rate you get:
>
> wget
> http://ftp.utexas.edu/opensuse/factory/iso/openSUSE-NET-x86_64-Build0018-Media.iso

So that command ran at essentially the rates you report for 10-20
seconds.  Then I killed it and tried another test I'd been using, which
was to lftp to ftp.kernel.org and get -c linux-2.6.39-rc7.tar.bz2.  That
transfer started at a high rate, but settled fairly quickly at about
60KB/s.  So I killed that transfer and restarted the wget, and it ran
steadily at ~60KB/s.

One question.  While I'm fairly certain that I'm running your patch,
would there be an easy way for me to be certain?  Perhaps I could add a
log message?

Thanks
-- 
Rob Browning
rlb @defaultvalue.org and @debian.org
GPG as of 2002-11-03 14DD 432F AE39 534D B592 F9A0 25C8 D377 8C7E 73A4
