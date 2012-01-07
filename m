Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40753 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab2AGVEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 16:04:12 -0500
Received: by wgbdr10 with SMTP id dr10so526166wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2012 13:04:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANUX_P22vWv+XenOLs7Smf2P7CpPCVperF5JagS2JyCCpHXKOQ@mail.gmail.com>
References: <201201071127.06717.toralf.foerster@gmx.de>
	<CANUX_P22vWv+XenOLs7Smf2P7CpPCVperF5JagS2JyCCpHXKOQ@mail.gmail.com>
Date: Sat, 7 Jan 2012 23:04:11 +0200
Message-ID: <CANUX_P2uzZwpCTcfgAu09PAcE-uUDCW0FMQK77P32cjwS2Hy9Q@mail.gmail.com> (sfid-20120107_220415_770842_0A46FA51)
Subject: Re: suggestion for a reasonable value for /sys/module/iwlwifi/parameters/debug
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 7, 2012 at 22:55, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> If I choosed 0x43ff my syslog message files exploded - and I'd like to trouble
>> shoot a problem with my wlan at a ThinkPad T400 (iwlwifi, 5100 AGN controler).
>> The symptoms are that 1-2 times in a hour the network stops working without
>> any message in /var/log/messages (kernel 3.0.x, 3.1.x, 3.2.0 tested).
>>
>> Thanks for any advice
>> --
>
> For this kind of issues I added the TX_QUEUES debug flags, but I just
> checked and it is not in 3.2. It is in John's wireless tree though. It
> is bit 31: debug=0x80000000
>
> BTW - John, I have tried many times to understand all this, but stupid
> me, couldn't ever make it. How come a patch is in wireless which in my
> understanding (probably wrong) is supposed to feed the current rc
> cycle (meaning the 3.2-rcX which just ended) and not be in 3.2 stable
> release ? Sorry for the ignorance...
>
Or maybe the wireless tree has already be recreated on top of Linus's
tree (through Dave's tree) after he merged everything ?
