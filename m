Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58982 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755304AbdDMTYq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 15:24:46 -0400
Message-ID: <1492111480.29526.7.camel@sipsolutions.net> (sfid-20170413_212508_985975_781A144C)
Subject: Re: [PATCH 1/5] netlink: extended ACK reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: nicolas.dichtel@6wind.com, David Ahern <dsa@cumulusnetworks.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pravin Shelar <pshelar@nicira.com>, dev@openvswitch.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>
Date: Thu, 13 Apr 2017 21:24:40 +0200
In-Reply-To: <28b0d93a-7e96-f7eb-b140-afc9ad429c30@6wind.com> (sfid-20170413_160541_831386_A409D7A6)
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
         (sfid-20170413_160541_831386_A409D7A6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-13 at 16:05 +0200, Nicolas Dichtel wrote:

> Sure. It was just to mention that attribute 0 exists somewhere.
> The other 0 attribute is OVS_TUNNEL_KEY_ATTR_ID.

That looks like some really awkward hand-grown parsing - with all these
"struct ovs_len_tbl" looking almost like a policy, but not using that
code?

Seems like something somebody should take a hard look at and see if it
can't use more standard infrastructure.

johannes
