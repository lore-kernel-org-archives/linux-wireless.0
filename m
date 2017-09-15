Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34112 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750838AbdIOHXW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 03:23:22 -0400
Message-ID: <1505460197.31630.29.camel@sipsolutions.net> (sfid-20170915_092325_517327_A5D59321)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        Denis Kenzior <denkenz@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 15 Sep 2017 09:23:17 +0200
In-Reply-To: <e7380aff-7e48-cfcb-b40d-530ac428a137@candelatech.com>
References: <1505378361.31630.2.camel@sipsolutions.net>
         <e4a3ab99-f49a-0849-56d7-71ce19b1f323@broadcom.com>
         <1505389462.31630.6.camel@sipsolutions.net>
         <e418234f-00a0-dd44-7352-d279f49f83e5@gmail.com>
         <1505416658.31630.15.camel@sipsolutions.net>
         <9219316a-5556-6acf-30de-e9aa65a05706@gmail.com>
         <6d0ad07b-ca89-19a1-d3c2-ad94915b942a@candelatech.com>
         <c2a820c4-f169-6a4d-13f3-3df323f1556a@gmail.com>
         <5436d106-0b4a-9158-58bf-ff84b231cd19@candelatech.com>
         <c97ecdb4-fe7a-e79a-d73e-32166beb1e11@gmail.com>
         <8a26a838-adde-08f1-5f64-c98e1d947675@candelatech.com>
         <756be45c-fd13-56a7-b8d4-129c4fd07dc8@gmail.com>
         <c33e5aed-be5a-890d-cc50-b5ac87b40d9a@candelatech.com>
         <5ec7a05e-dfa4-37e0-b108-51ca0885b9a7@gmail.com>
         <038474b0-4d37-9bb7-ebf0-b92564abf5af@candelatech.com>
         <4aef67e2-7476-71d7-7692-cf6ed3f6c5b8@gmail.com>
         <e7380aff-7e48-cfcb-b40d-530ac428a137@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-09-14 at 15:57 -0700, Ben Greear wrote:
> 
> What about two APs with ssid LEDE and open-auth, each serving DHCP,
> each connected to a switch that connects to a cable modem, etc.

Take a cluebat to the adminstrator?

It's really simple to disable DHCP on one of them, and if you properly
connect them to the same switch, everything works. I've done that in a
few places (not my own house because a single AP covers it well enough
for me, so ...).

> On initial connection to the network, the station does DHCP and gets
> a response, like normal.
> But, that response has a special message in it that says "you don't
> need to re-do dhcp if you roam here".
> User-space remembers this response for future roams...
> 
> After that, then you skip DHCP on roam to this SSID/auth network, so
> you have zero extra network overhead when roaming.

That will be so much harder to configure.

johannes
