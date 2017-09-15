Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34058 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdIOHUa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 03:20:30 -0400
Message-ID: <1505460025.31630.27.camel@sipsolutions.net> (sfid-20170915_092033_475778_B1BF46C0)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        Denis Kenzior <denkenz@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 15 Sep 2017 09:20:25 +0200
In-Reply-To: <c33e5aed-be5a-890d-cc50-b5ac87b40d9a@candelatech.com>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-09-14 at 13:47 -0700, Ben Greear wrote:

> Seems like we would need some way for the DHCP server and/or AP to
> proactively notify the station that they can skip DHCP, and default
> to not skipping.

I really disagree with that - every sane network should behave the
proper way, trying to push workarounds for stupid networks into all
layers of the stack seems like a really bad idea.

johannes
