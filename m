Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:37083 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdCRWWZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Mar 2017 18:22:25 -0400
Received: by mail-it0-f43.google.com with SMTP id g138so61725000itb.0
        for <linux-wireless@vger.kernel.org>; Sat, 18 Mar 2017 15:22:24 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
Subject: ANNOUNCE: New talk accepted on TCP algorithms performance on wireless
 LTE networks
To: people@netdevconf.org
Cc: tech-committee@netdevconf.org, netfilter-devel@vger.kernel.org,
        Brenda Butler <bjb@mojatatu.com>,
        Stephen Jaworski <jaws@mojatatu.com>,
        netfilter@vger.kernel.org, linux-wireless@vger.kernel.org,
        Heri Muhero <hmuhero@gmail.com>
Message-ID: <3cafd981-9a0f-9dc4-66a3-351952fae808@mojatatu.com> (sfid-20170318_232231_475212_2DB8CF02)
Date: Sat, 18 Mar 2017 18:22:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Someone complained in the last posting that I was "spamming" them.
If a list admin feels these announcements of a community event as
spam - please unicast me and I will remove you off future
announcements.

The tech committee would like to announce a new accepted talk.

Jae Won Chung and Feng Li (at Verizon) have done a lot of work on
analyzing the effect of the different Linux TCP congestion control
algorithms on LTE wireless networks while driving on a fast
highway/road. In this talk they compare CUBIC to BBR.

A little bit more details:

----
Unlike IEEE802.11 (wifi) and traditional 3G wireless links,  LTE
networks have high link variability and large end user mobility.
There still exists a huge gap in understanding how TCP congestion
control algorithms variants perform under such conditions.
Mobile carriers often waste their efforts to improve throughput by
fine tuning parameters of TCP CUBIC although CUBIC often fails to ramp
up rapidly to congestion avoidance needs over LTE links.

To have a better understanding of TCP performance over LTE networks, we
conduct a comprehensive measurement study to compare CUBIC with its
latest rival - BBR over a world leading tier-one mobile network in high
speed driving condition.
To our best knowledge, there is no measurement effort to compare
performance of different TCP flavors over LTE networks on highway. In
addition to our measurement contribution, our in-depth measurement
result also conclude that:
1) CUBIC with Hybrid slow start leads to a low radio resource
utilization;
2) BBR yields higher throughputs even when SINR is lower and/or hand-off
happens;
3) BBR's bottle-neck link bandwidth estimation works well for various
conditions (including hand-offs); and
4)BBR is a promising TCP Congestion Control candidate for
performance enhancement proxies over mobile networks.

----

cheers,
jamal
