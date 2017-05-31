Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:52327 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751503AbdEaITL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 04:19:11 -0400
Date: Wed, 31 May 2017 10:18:36 +0200
From: Bastian Bittorf <bb@npl.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 'iw events' stops receiving events after a while on 4.9 + hacks
Message-ID: <20170531081836.GC2849@medion.lan> (sfid-20170531_101923_565848_B229A53E)
References: <d82d191e-8ede-68c6-c9e0-c381dc874d36@candelatech.com>
 <20170517100844.GC2849@medion.lan>
 <1495027835.2442.13.camel@sipsolutions.net>
 <fa96dfad-8d1b-c48f-df3b-3df0d548a5c6@candelatech.com>
 <1496150322.3327.9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1496150322.3327.9.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Johannes Berg <johannes@sipsolutions.net> [31.05.2017 10:09]:
> > Is there any way to dump out the socket information if we reproduce
> > the problem?
> 
> I have no idea, sorry.
> 
> If you or Bastian can tell me how to reproduce the problem, I can try
> to investigate it.

there was an interesting fix regarding the shell-builtin 'read' in
busybox[1]. I will retest again and report if this changes anything.

bye, bastian

PS: @ben: are you also using 'iw event | while read -r LINE ...'?

[1]
https://git.busybox.net/busybox/commit/?id=f5470419404d643070db99d058405b714695b817
