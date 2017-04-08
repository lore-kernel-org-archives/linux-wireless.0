Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38876 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752426AbdDHShz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Apr 2017 14:37:55 -0400
Message-ID: <1491676670.5800.25.camel@sipsolutions.net> (sfid-20170408_203810_861642_B1EC6313)
Subject: Re: [PATCH 1/5] netlink: extended ACK reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: David Ahern <dsa@cumulusnetworks.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>, jiri@resnulli.us
Date: Sat, 08 Apr 2017 20:37:50 +0200
In-Reply-To: <14c58480-cd03-4d61-fffa-fab6e437a7ea@cumulusnetworks.com> (sfid-20170408_203643_247519_552A8ABE)
References: <20170408174900.12820-1-johannes@sipsolutions.net>
         <20170408174900.12820-2-johannes@sipsolutions.net>
         <14c58480-cd03-4d61-fffa-fab6e437a7ea@cumulusnetworks.com>
         (sfid-20170408_203643_247519_552A8ABE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-04-08 at 14:36 -0400, David Ahern wrote:
> 
> I think v3 is in your future ...
> 
> /home/dsa/kernel-4.git/include/linux/netlink.h:78:12: error:
> ‘NETLINK_MAX_COOKIE_LEN’ undeclared here (not in a function)
>   u8 cookie[NETLINK_MAX_COOKIE_LEN];
>             ^
> 
> it's defined in patch 3; needed in patch 1

Damn. Ok, that'll have to wait until Monday, unless the airport has
useful wifi.

johannes
