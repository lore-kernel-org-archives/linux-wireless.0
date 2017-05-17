Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:53287 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752482AbdEQKIa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 06:08:30 -0400
Date: Wed, 17 May 2017 12:08:45 +0200
From: Bastian Bittorf <bb@npl.de>
To: Ben Greear <greearb@candelatech.com>
Cc: netdev <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 'iw events' stops receiving events after a while on 4.9 + hacks
Message-ID: <20170517100844.GC2849@medion.lan> (sfid-20170517_120840_185521_D3BC3321)
References: <d82d191e-8ede-68c6-c9e0-c381dc874d36@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d82d191e-8ede-68c6-c9e0-c381dc874d36@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Ben Greear <greearb@candelatech.com> [17.05.2017 11:51]:
> I have been keeping an 'iw events' program running with a perl script gathering its
> output and post-processing it.  This has been working for several years on 4.7 and earlier
> kernels, but when testing on 4.9 overnight, I notice that 'iw events' is not showing any input.  'strace' shows
> that it is waiting on recvmsg.  If I start a second 'iw events' then it will get
> wifi events as expected.

me too, also seen on 4.4 - i'am happy for debug ideas.

bye, bastian
