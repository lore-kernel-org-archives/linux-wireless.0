Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36550 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdCNMLm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 08:11:42 -0400
Received: by mail-io0-f196.google.com with SMTP id 68so16153205ioh.3
        for <linux-wireless@vger.kernel.org>; Tue, 14 Mar 2017 05:11:36 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
Subject: ANNOUNCE: New talk accepted on Netesto tool suite
To: people@netdevconf.org
Cc: tech-committee@netdevconf.org, netfilter-devel@vger.kernel.org,
        Brenda Butler <bjb@mojatatu.com>,
        Stephen Jaworski <jaws@mojatatu.com>,
        netfilter@vger.kernel.org, linux-wireless@vger.kernel.org,
        Heri Muhero <hmuhero@gmail.com>
Message-ID: <f3f5ac35-b685-a2f6-ed89-277996dc3c17@mojatatu.com> (sfid-20170314_131149_595075_BCBAC321)
Date: Tue, 14 Mar 2017 08:11:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tech committee would like to announce a new accepted talk.

Lawrence Brakmo  will talk about Netesto tool suite

Details are as follows:
-----
Netesto (NEtwork TESting TOolkit) is a suite of tools for running 
multi-host network experiments that supports the collection and display 
of relevant data and statistics. It currently supports TCP RPC and 
STREAM transfers through netperf. Although the framework itself can 
easily be expanded to support other protocols and transfer programs. It 
has some similarities to Flent (The Flexible Network Tester) in that it 
is based on Python, but unlike Flent, Netesto supports:

Multiple senders and receivers
Detailed flow information: RTTs, cwnds, etc.
Per host statistics and state
Creation of csv file with results
Creation of html file with results in table plus detailed results 
including graphs of cwnds, RTTs, goodput
Support for creating complex scenarios through macros
Support for adding delays with netem
Netesto can run complex scenarios consisting of multiple individual 
tests with just a few commands due to the use of macros and libraries. 
The end result is an HTML page consisting of a table with one or more 
lines per test, plus links to pages for individual results which contain 
graphs showing goodputs, RTTs and cwnds. Netesto has proved very 
valuable for comparing the performance of different TCP variants (such 
as Cubic, Reno, BBR, NV). For example, it was used to evaluate BBR and 
compare its performance to Cubic 
(https://drive.google.com/file/d/0B4YZ_0yTgbJEa21CbUVLWFdrX2c/view)
----

cheers,
jamal
