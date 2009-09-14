Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45185 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbZINSUY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 14:20:24 -0400
Received: by bwz19 with SMTP id 19so2277889bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 11:20:26 -0700 (PDT)
Message-ID: <4AAE8965.4040108@lwfinger.net>
Date: Mon, 14 Sep 2009 13:20:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel oops with 2.6.31-wl
References: <4AAE4DAA.1010505@lwfinger.net> <1252950017.23427.49.camel@johannes.local>
In-Reply-To: <1252950017.23427.49.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2009-09-14 at 09:05 -0500, Larry Finger wrote:
>> Using the kernel v2.6.31-38241-g2d3a51e, I get the following kernel
>> oops when unloading b43:
> 
>> RIP: 0010:[<ffffffffa02a3a3e>]  [<ffffffffa02a3a3e>]
>> b43_op_config+0x10c/0x36f [b43]
> 
> Seems like a b43 problem to me.

I had pretty much reached that conclusion. I will need to swap cards
to debug as the 4315 won't run on older kernels without a lot of patches.

Larry
