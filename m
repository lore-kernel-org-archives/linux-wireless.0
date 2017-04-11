Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34791 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdDKI50 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 04:57:26 -0400
Received: by mail-wr0-f195.google.com with SMTP id u18so24236793wrc.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Apr 2017 01:57:25 -0700 (PDT)
Date: Tue, 11 Apr 2017 10:57:23 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Ahern <dsa@cumulusnetworks.com>
Subject: Re: [PATCH net-next v4 1/5] netlink: extended ACK reporting
Message-ID: <20170411085723.GE1976@nanopsycho> (sfid-20170411_105738_751154_F3508384)
References: <20170411065700.2623-1-johannes@sipsolutions.net>
 <20170411065700.2623-2-johannes@sipsolutions.net>
 <20170411071900.GC1976@nanopsycho>
 <1491895758.31620.4.camel@sipsolutions.net>
 <20170411081346.GD1976@nanopsycho>
 <1491899392.31620.14.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1491899392.31620.14.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tue, Apr 11, 2017 at 10:29:52AM CEST, johannes@sipsolutions.net wrote:
>On Tue, 2017-04-11 at 10:13 +0200, Jiri Pirko wrote:
>> Tue, Apr 11, 2017 at 09:29:18AM CEST, johannes@sipsolutions.net
>> wrote:
>> > On Tue, 2017-04-11 at 09:19 +0200, Jiri Pirko wrote:
>> > > 
>> > > > +	NUM_NLMSGERR_ATTRS,
>> > > 
>> > > According to the rest of the uapi, this should be rather named:
>> > > 	__NLMSGERR_ATTR_MAX
>> > 
>> > nl80211 uses NUM_ so I guess that's a matter of convention, but I
>> > can
>> > change that I guess.
>> 
>> Please do.
>
>No further comments on any other parts of the patch(es)? :)

I didn't found anything aside the narrow descriptions- you have it like
that in 4 out of 5 patches :)


>
>I don't want to be resending all the time, so I guess I'll wait. For
>now, all code is in the nl-err branch in mac80211-next.
>
>johannes
