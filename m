Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54857 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbZINUu0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 16:50:26 -0400
Received: by bwz19 with SMTP id 19so2375200bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 13:50:28 -0700 (PDT)
Message-ID: <4AAEAC90.7070205@lwfinger.net>
Date: Mon, 14 Sep 2009 15:50:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel oops with 2.6.31-wl
References: <4AAE4DAA.1010505@lwfinger.net> <1252950017.23427.49.camel@johannes.local> <4AAE8965.4040108@lwfinger.net> <200909142245.52042.mb@bu3sch.de>
In-Reply-To: <200909142245.52042.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Monday 14 September 2009 20:20:21 Larry Finger wrote:
>> Johannes Berg wrote:
>>> On Mon, 2009-09-14 at 09:05 -0500, Larry Finger wrote:
>>>> Using the kernel v2.6.31-38241-g2d3a51e, I get the following kernel
>>>> oops when unloading b43:
>>>> RIP: 0010:[<ffffffffa02a3a3e>]  [<ffffffffa02a3a3e>]
>>>> b43_op_config+0x10c/0x36f [b43]
>>> Seems like a b43 problem to me.
>> I had pretty much reached that conclusion. I will need to swap cards
>> to debug as the 4315 won't run on older kernels without a lot of patches.
> 
> I can't reproduce here. What sequence of events is needed to trigger this?

All I have to do is make a connection, then "sudo modprobe -rv b43"
while the connection is live. I have not tried shutting the interface
down before the modprobe. It gets through the "rmmod b43" and the
"rmmod ssb" and then crashes.

Larry
