Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33945 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932466AbdCWSqh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Mar 2017 14:46:37 -0400
Received: by mail-io0-f193.google.com with SMTP id n76so492515ioe.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Mar 2017 11:46:36 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [ANNOUNCE]: New sponsor and accepted talk
To: people@netdevconf.org
Cc: tech-committee@netdevconf.org, netfilter-devel@vger.kernel.org,
        Brenda Butler <bjb@mojatatu.com>,
        Stephen Jaworski <jaws@mojatatu.com>,
        netfilter@vger.kernel.org, linux-wireless@vger.kernel.org,
        Heri Muhero <hmuhero@gmail.com>
Message-ID: <3a7c4196-2812-4894-2f4e-a7d1c88fa650@mojatatu.com> (sfid-20170323_194641_448000_31557A60)
Date: Thu, 23 Mar 2017 14:46:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Two announcements for today. An accepted talk and a new sponsor.

1) The tech committee would like to announce a new accepted talk.
Arthur Davis and Tom Distler will talk about their quest for a
quest for a network configuration solution for a large Linux storage
application

Details are as follows:
-------
This talk is about our quest for a network configuration solution
for a large Linux storage application. Our application is based on
a highly available cluster architecture which requires
dynamic and reliable software-driven network configuration.

Further requirements include:
- programmatic access to configure the majority of the Linux network
   stack,
- transaction-like semantics where multiple related configurations
   either fail or succeed as a unit,
- logic to monitor the system and when it differs from the expected
   configuration, provide notifications and possibly attempt automatic
   repairs,
- and all of this without becoming entangled with application-specific
   expectations about behaviors and policies.

The talk expands upon the above set of core requirements and discusses
some of the difficulties around meeting these requirements with
currently available open source solutions. Our journey leads to a new
configuration system to meet these requirements, and we discuss some
key architecture and design aspects of the system.

We are planning to release our work into the open source community and
we hope the talk will encourage discussion and provide us feedback on
making this work better.
--------

2) The organizing committee would like to announce
Savoirfairelinux  joining as a bronze sponsor. Thank you!


cheers,
jamal
