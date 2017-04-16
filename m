Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35152 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755625AbdDPOsz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 10:48:55 -0400
Received: by mail-io0-f196.google.com with SMTP id d203so20638730iof.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 07:48:54 -0700 (PDT)
Subject: Re: second wave of netlink extended ACK reporting
To: David Ahern <dsa@cumulusnetworks.com>,
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
 <c75ab5ec-d33e-256d-1222-590dd22c5b08@cumulusnetworks.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jiri Benc <jbenc@redhat.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <280d0c61-4506-f721-1536-4afb2daabef8@mojatatu.com> (sfid-20170416_164900_444953_A59A6F75)
Date: Sun, 16 Apr 2017 10:48:52 -0400
MIME-Version: 1.0
In-Reply-To: <c75ab5ec-d33e-256d-1222-590dd22c5b08@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-04-16 10:45 AM, David Ahern wrote:
> On 4/16/17 8:40 AM, Jamal Hadi Salim wrote:
>>
>> Johannes or anybody else working on it?
>> i.e one which sends the extack to the bowels of callees
>> so we can return meaningful messages
>> example: rtnetlink::doit() or equivalent seems to be a candidate for
>> taking it as a param
>
> I have a patch for the first pass on rtnetlink doit path. plumbs the
> extack parameter and covers the nlmsg_parse case.  I'll send it once
> Johannes' patches go in.
>

Excellent. His patches seem to be in. Seems
commit ce07183282975026716107d36fd3f5f93de76668
is a good point?

cheers,
jamal
