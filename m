Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:36565 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756061AbdDPQzS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 12:55:18 -0400
Received: by mail-pf0-f178.google.com with SMTP id 194so17723799pfv.3
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 09:55:18 -0700 (PDT)
Subject: Re: second wave of netlink extended ACK reporting
To: Jamal Hadi Salim <jhs@mojatatu.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        nicolas.dichtel@6wind.com, Jiri Pirko <jiri@resnulli.us>,
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
 <826de765-dd18-f6a3-8e37-7b55398ad99b@mojatatu.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jiri Benc <jbenc@redhat.com>
From: David Ahern <dsa@cumulusnetworks.com>
Message-ID: <4846bb66-d169-dba7-7a1e-0665fe41083d@cumulusnetworks.com> (sfid-20170416_185523_283081_A5F1F061)
Date: Sun, 16 Apr 2017 10:55:14 -0600
MIME-Version: 1.0
In-Reply-To: <826de765-dd18-f6a3-8e37-7b55398ad99b@mojatatu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/16/17 8:40 AM, Jamal Hadi Salim wrote:
> 
> Johannes or anybody else working on it?
> i.e one which sends the extack to the bowels of callees
> so we can return meaningful messages
> example: rtnetlink::doit() or equivalent seems to be a candidate for
> taking it as a param
> For things that call netlink_ack it may be easier if they create
> the extack.
> For dumps it makes it tricky since their lifetime is much
> longer..


I have a start to a patch for iproute2 as well. It needs some
improvements before I can send it. Should be able to get to it Monday or
Tuesday.
