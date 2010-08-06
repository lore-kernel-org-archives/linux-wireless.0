Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43319 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab0HFN7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 09:59:42 -0400
Date: Fri, 6 Aug 2010 09:50:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Odd BUG on wireless-testing master-2010-08-05
Message-ID: <20100806135057.GA2753@tuxdriver.com>
References: <AANLkTinwbLXVHmC9eUczoe-ntT=adyFFx6C6Q=GcBc79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTinwbLXVHmC9eUczoe-ntT=adyFFx6C6Q=GcBc79@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 05, 2010 at 03:31:06PM -0700, Luis R. Rodriguez wrote:
> I just ran into this. My first load of master-2010-08-05 was fine but
> I started getting a lot of disconnects on AR9003 hardware after a
> period of RX'ing data over an encrypted legacy network. Instead of
> checking dmesg I just rebooted though. After that I connected to the
> same AP again, started Rx'ing for a while and then shortly got this:
> 
> 
> [  818.749585] BUG: unable to handle kernel paging request at 00003f3f00000000
> [  818.749594] IP: [<ffffffff814ee0d8>] unix_stream_recvmsg+0x3f8/0x790

> After a reboot I got a hard hang which I could not capture any logs
> for. I rebooted and am up now but not seeing these issues yet. John,
> does this smell like what you were seeing or is this different?

Yeah, I'm seeing that too.  There is some netdev stuff in
wireless-testing at the moment that I suspect was undercooked...

Sorry for the inconvenience while this gets sorted-out!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
