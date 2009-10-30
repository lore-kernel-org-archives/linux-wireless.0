Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36449 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223AbZJ3ULK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 16:11:10 -0400
Received: by bwz27 with SMTP id 27so3995462bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2009 13:11:14 -0700 (PDT)
Message-ID: <4AEB485E.1000108@lwfinger.net>
Date: Fri, 30 Oct 2009 15:11:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Malte Gell <malte.gell@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: ar9170usb from compat-wireless-2009-10-28
References: <200910302100.08566.malte.gell@gmx.de>
In-Reply-To: <200910302100.08566.malte.gell@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Malte Gell wrote:
> Hello!
> 
> I use a Fritz! WLAN N stick and the ar9170usb driver, but with compat-wireless 
> from 2009-10-28 I get no USB connection LED burning...
> 
> compat-wireless 2009-09-29 was okay, it has enabled both LEDs. So I wonder, is 
> it safe to use older compat-wireless-2009-09-29?

Does it work? What would be unsafe?

> I use Linux kernel 2.6.32-rc5-git3 on openSUSE 11.1

Is there a reason that you need compat-wireless with 2.6.32-rc5-git3?
Most of the changes in compat-wireless are already in 2.6.32-rc3.

As long as you are using a git kernel, you ought to use git to
download the kernel from Linville's wireless-testing git tree. That
way, you will always have what is in the latest wireless-testing. In
addition, your reports of problems will be for the current state and
you can help with the debugging.

