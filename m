Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:59027 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbYENEwa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 00:52:30 -0400
Subject: Re: newbie rtl8187 question
From: Pavel Roskin <proski@gnu.org>
To: Paul Thomas <pthomas8589@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <c785bba30805132141l62bef2d7n4d78a95510ed6a3d@mail.gmail.com>
References: <c785bba30805132014y56aafa7bi8788503f67a7c809@mail.gmail.com>
	 <1210736718.2721.4.camel@rd>
	 <c785bba30805132050y51cc3031uae718bc74ade96@mail.gmail.com>
	 <1210737929.2721.19.camel@rd>
	 <c785bba30805132141l62bef2d7n4d78a95510ed6a3d@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 00:52:28 -0400
Message-Id: <1210740748.2721.62.camel@rd> (sfid-20080514_065234_112313_4A060EAD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-13 at 21:41 -0700, Paul Thomas wrote:
> Thanks,
> 
> That worked! I unplugged my ethernet cable, and I'm sending this via
> the wireless adapter.

Nice to hear that!!!

> If I can get some other patches on this same tree I can test the
> driver on an arm9 processor (Atmel AT91RM9200). I'll let you know.
> 
> Any idea when those patches will find there way to the main line kernel?

Since the code is working, it's likely to be in linux-wireless within
days, which means in will be scheduled for Linux 2.6.27.  2.6.26 is in
the RC phase now, but I've seen a similar patch for Broadcom going into
2.6.25 quite late in the game, so we can hope that 2.6.26 may have the
rtl8187b fix too.

-- 
Regards,
Pavel Roskin
