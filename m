Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33214 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755760AbdDPOlC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 10:41:02 -0400
Received: by mail-io0-f193.google.com with SMTP id k87so22689774ioi.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 07:41:02 -0700 (PDT)
Subject: second wave of netlink extended ACK reporting
To: Johannes Berg <johannes@sipsolutions.net>,
        nicolas.dichtel@6wind.com, David Ahern <dsa@cumulusnetworks.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pravin Shelar <pshelar@nicira.com>, dev@openvswitch.org
References: <20170408174900.12820-1-johannes@sipsolutions.net>
 <20170408174900.12820-2-johannes@sipsolutions.net>
 <20170408183440.GA1900@nanopsycho>
 <1491676621.5800.24.camel@sipsolutions.net>
 <20170408184008.GB1900@nanopsycho>
 <990b5610-a894-b3d2-d3a7-536dfd25adb8@cumulusnetworks.com>
 <1491805089.2455.3.camel@sipsolutions.net>
 <c0b35e6e-e5cb-25f6-7ccf-eec33ba39f3b@6wind.com>
 <1492090170.29526.1.camel@sipsolutions.net>
 <28b0d93a-7e96-f7eb-b140-afc9ad429c30@6wind.com>
 <1492111480.29526.7.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jiri Benc <jbenc@redhat.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <826de765-dd18-f6a3-8e37-7b55398ad99b@mojatatu.com> (sfid-20170416_164110_052418_AC6EF045)
Date: Sun, 16 Apr 2017 10:40:59 -0400
MIME-Version: 1.0
In-Reply-To: <1492111480.29526.7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Johannes or anybody else working on it?
i.e one which sends the extack to the bowels of callees
so we can return meaningful messages
example: rtnetlink::doit() or equivalent seems to be a candidate for
taking it as a param
For things that call netlink_ack it may be easier if they create
the extack.
For dumps it makes it tricky since their lifetime is much
longer..

cheers,
jamal
