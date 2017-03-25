Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:32908 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbdCYPGy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Mar 2017 11:06:54 -0400
Received: by mail-it0-f48.google.com with SMTP id w124so10791547itb.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Mar 2017 08:06:53 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [Netdev ANNOUNCE]: New talk accepted
To: people@netdevconf.org
Cc: tech-committee@netdevconf.org, netfilter-devel@vger.kernel.org,
        Brenda Butler <bjb@mojatatu.com>,
        Stephen Jaworski <jaws@mojatatu.com>,
        netfilter@vger.kernel.org, linux-wireless@vger.kernel.org,
        Heri Muhero <hmuhero@gmail.com>
Message-ID: <c82335d3-cd46-a2af-7b4b-4c888ad63999@mojatatu.com> (sfid-20170325_160708_873211_83FEEB3C)
Date: Sat, 25 Mar 2017 10:59:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


The tech committee would like to announce a new accepted talk.

Tom Herbert will talk about the need for very critical (life or death!)
infrastructure need for IOT.


More details on the talk:

----
This talks presents the motivation and direction to support the
emerging class of IoT applications and protocols that require latencies
measured in milliseconds on the Internet. These may be thought of as
"life-critical applications" in the sense that they could be a matter
of life and death to be correct. For example, a camera monitoring an
intersection by a school may detect a child darting out into traffic. A
device attached to the camera may send a warning to an autonomous
vehicle to apply brakes to avoid hitting the child. The difference in
reaction time between the an automated system and human is stark--
about 40 msecs compared to 500 msecs or more for a human.

Real-time IoT protocols need to be implemented with very low latency
from hazard detection to response, strict latency bounds, be highly
available, be secure (critical messages can't be spoofed), and be
resistant to DDOS. A primary use case for such applications, as
exhibited in the above example, is so-called Vehicle to Infrastructure
communications (V2X). This implies that communicating devices may be
highly mobile needing a solution such as ILA or MobileIP. The
underlying network may also have different flavors including Dedicated
Short-Range Communications (DSRC) which is standardized as 802.11p, 4G
or the emerging 5G standard, as well as traditional WIFI.

In order to achieve the tight latency bounds the application, network
stack, network, scheduling, must all be tightly coordinated.
Information is usually time sensitive with deadlines of usefulness such
that techniques such as forward error correction are more likely to be
used than traditional reliable protocols such as TCP. DTLS handshake
must also be low latency, as well as any hand-off for implemented
MobileIP.
-----


cheers,
jamal
