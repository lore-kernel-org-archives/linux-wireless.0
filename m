Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63838 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965446Ab0HFTFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 15:05:25 -0400
Received: by iwn33 with SMTP id 33so1516144iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 12:05:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100806135057.GA2753@tuxdriver.com>
References: <AANLkTinwbLXVHmC9eUczoe-ntT=adyFFx6C6Q=GcBc79@mail.gmail.com>
	<20100806135057.GA2753@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 6 Aug 2010 12:05:05 -0700
Message-ID: <AANLkTi=Q6K1xeDn6zmBD5co5aMgvDMyUqGE3vLoo4_2+@mail.gmail.com>
Subject: Re: Odd BUG on wireless-testing master-2010-08-05
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 6, 2010 at 6:50 AM, John W. Linville <linville@tuxdriver.com> wrote:
> On Thu, Aug 05, 2010 at 03:31:06PM -0700, Luis R. Rodriguez wrote:
>> I just ran into this. My first load of master-2010-08-05 was fine but
>> I started getting a lot of disconnects on AR9003 hardware after a
>> period of RX'ing data over an encrypted legacy network. Instead of
>> checking dmesg I just rebooted though. After that I connected to the
>> same AP again, started Rx'ing for a while and then shortly got this:
>>
>>
>> [  818.749585] BUG: unable to handle kernel paging request at 00003f3f00000000
>> [  818.749594] IP: [<ffffffff814ee0d8>] unix_stream_recvmsg+0x3f8/0x790
>
>> After a reboot I got a hard hang which I could not capture any logs
>> for. I rebooted and am up now but not seeing these issues yet. John,
>> does this smell like what you were seeing or is this different?
>
> Yeah, I'm seeing that too.  There is some netdev stuff in
> wireless-testing at the moment that I suspect was undercooked...
>
> Sorry for the inconvenience while this gets sorted-out!

Ah no problem, just wanted to see if I should dig into ath9k or not,
sounds like I don't. FWIW I had a hang overnight as well.

  Luis
