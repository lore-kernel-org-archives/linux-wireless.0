Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39940 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2AGUzb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 15:55:31 -0500
Received: by wgbdr10 with SMTP id dr10so523454wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2012 12:55:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201071127.06717.toralf.foerster@gmx.de>
References: <201201071127.06717.toralf.foerster@gmx.de>
Date: Sat, 7 Jan 2012 22:55:30 +0200
Message-ID: <CANUX_P22vWv+XenOLs7Smf2P7CpPCVperF5JagS2JyCCpHXKOQ@mail.gmail.com> (sfid-20120107_215551_848413_61C67136)
Subject: Re: suggestion for a reasonable value for /sys/module/iwlwifi/parameters/debug
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If I choosed 0x43ff my syslog message files exploded - and I'd like to trouble
> shoot a problem with my wlan at a ThinkPad T400 (iwlwifi, 5100 AGN controler).
> The symptoms are that 1-2 times in a hour the network stops working without
> any message in /var/log/messages (kernel 3.0.x, 3.1.x, 3.2.0 tested).
>
> Thanks for any advice
> --

For this kind of issues I added the TX_QUEUES debug flags, but I just
checked and it is not in 3.2. It is in John's wireless tree though. It
is bit 31: debug=0x80000000

BTW - John, I have tried many times to understand all this, but stupid
me, couldn't ever make it. How come a patch is in wireless which in my
understanding (probably wrong) is supposed to feed the current rc
cycle (meaning the 3.2-rcX which just ended) and not be in 3.2 stable
release ? Sorry for the ignorance...

thanks
