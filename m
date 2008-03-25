Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:2920 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbYCYNmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 09:42:10 -0400
Received: by ug-out-1314.google.com with SMTP id z38so2379938ugc.16
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2008 06:42:08 -0700 (PDT)
To: Alejandro Riveira =?iso-8859-1?q?Fern=E1ndez?=
	<ariveira@gmail.com>
Subject: Re: Spammed logs again rt2500pci 2.6.25-rc6-00268-gd2532dd
Date: Tue, 25 Mar 2008 14:41:22 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20080117225744.29aa214c@Varda> <20080325131250.5167e311@Varda>
In-Reply-To: <20080325131250.5167e311@Varda>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803251441.22394.IvDoorn@gmail.com> (sfid-20080325_134219_952462_D4D538F2)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>  Linux Varda 2.6.25-rc6-00268-gd2532dd #1 SMP PREEMPT Mon Mar 24 14:44:13 CET
> 2008 x86_64 GNU/Linux
> 
> 
>  As the last time the thing is triggered with a p2p app making a lot of
>  connections deluge
>  
>  My logs are spammed with the same msgs as other reports.
>  If you need more info just ask.

This issue has been resolved for 2.6.26. The fix for this bug is of such a scale
that it could not easily be merged for 2.6.25.

>  PS: i will not bother to make a report in the web forums becouse the last time
> i was ignored.

You mean http://rt2x00.serialmonkey.com/phpBB2/index.php?
'ignored' is not the right word, more likely overlooked.
There are quite a lot of messages and I don't always have time to answer them all.
So there is no need to be upset about such thing, simply posting a reminder is usually
enough to make it noticed by me...

> (Someone may want to change the web forums pointer in the logs to 
> the linux-wireless mailing list)

What pointer? And rt2400-devel is the mailinglist for rt2x00...
The MAINTAINERS file in the kernel tree indicates 2 mailinglists for rt2x00:
	rt2400-devel@lists.sourceforge.net
	linux-wireless@vger.kernel.org

Ivo
