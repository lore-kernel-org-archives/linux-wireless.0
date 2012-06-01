Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43981 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965188Ab2FAQAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 12:00:54 -0400
Received: by yhmm54 with SMTP id m54so1753219yhm.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jun 2012 09:00:54 -0700 (PDT)
Message-ID: <4FC8E733.6030905@lwfinger.net> (sfid-20120601_180058_790781_3197A1CF)
Date: Fri, 01 Jun 2012 11:00:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jacopo Runchi <jacoporunchi@hotmail.it>
CC: linux-wireless@vger.kernel.org
Subject: Re: I: RTL8187 driver in linux 3.4
References: <!&!AAAAAAAAAAAuAAAAAAAAAH2SKMTPZA1PmAOs8RWvl9YBANlTnCJhprtFudq2LHCBs8EBACQA//8AABAAAACIF7qVX5kVSJrDEtYsG/e+AQAAAAA=@hotmail.it> <DUB107-ds5BA2D5341A3C373209B17A0080@phx.gbl>
In-Reply-To: <DUB107-ds5BA2D5341A3C373209B17A0080@phx.gbl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/01/2012 09:50 AM, Jacopo Runchi wrote:
> Thank you for the help on the request below.
>
> Bye, Jacopo.
>
> *Da:*Jacopo Runchi [mailto:jacoporunchi@hotmail.it]
> *Inviato:* venerdì 1 giugno 2012 15:21
> *A:* 'herton@canonical.com'; 'htl10@users.sourceforge.net';
> 'Larry.Finger@lwfinger.net'
> *Oggetto:* RTL8187 driver in linux 3.4
>
> Hi, I write to you because I found you are the maintainers of the driver in subject.
>
> Hi, I’m working with a USB device using chipset RTL8187 connected to a mips
> router with Openwrt.
>
> With the old driver r8187l.ko in linux 2.4.x it works fine.
>
> With the RTL8187 driver, if the signal is not good enough, it can establish a
> connection, but it doesn’t transfer datas (no ping for example).
>
> I think it is a bug of the driver, so I would like to know if you know this bug
> and if you have planned to solve it…
>
> There is any change planned on this driver?
>
> I hope for a generous answer and I’m sorry for my bad English.

The address looks OK to me. I do not know why it bounced.

My involvement with the RTL8187 devices only started with 2.6.X, where X is 25 
or 26. I have no knowledge of the driver in kernel 2.4.

There have been various complaints about the driver, particularly on RTL8187L 
hardware, that concern rate setting using the minstrel algorithm. I have been 
unable to reproduce the results.

Please answer the following questions;

Does the device work is you lock the rate at 1 Mbps?

What is the USB ID as shown by lsusb?

Does it work when you use the PID rate-setting algorithm? To enable this, you 
will need to set CONFIG_EXPERT=y.

Larry


Does it work better if you choose
