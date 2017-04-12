Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35883 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752484AbdDLNYx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 09:24:53 -0400
Received: by mail-wm0-f65.google.com with SMTP id q125so6393380wmd.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2017 06:24:52 -0700 (PDT)
Date: Wed, 12 Apr 2017 15:24:50 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Ahern <dsa@cumulusnetworks.com>
Subject: Re: [PATCH net-next v5 4/5] netlink: pass extended ACK struct to
 parsing functions
Message-ID: <20170412132450.GD1952@nanopsycho> (sfid-20170412_152457_930096_A0B4E9A5)
References: <20170412123408.22012-1-johannes@sipsolutions.net>
 <20170412123408.22012-5-johannes@sipsolutions.net>
 <20170412131708.GC1952@nanopsycho>
 <1492003236.2855.5.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1492003236.2855.5.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wed, Apr 12, 2017 at 03:20:36PM CEST, johannes@sipsolutions.net wrote:
>On Wed, 2017-04-12 at 15:17 +0200, Jiri Pirko wrote:
>> Wed, Apr 12, 2017 at 02:34:07PM CEST, johannes@sipsolutions.net
>> wrote:
>> > From: Johannes Berg <johannes.berg@intel.com>
>> > 
>> > Pass the new extended ACK reporting struct to all of the
>> 
>> Johannes, I wonder, is there a reason you ignore my comments about
>> narrow descriptions? Why don't you use the whole line?
>
>I don't think it makes sense. Text is easier to read if it's narrower,
>80 columns was never desired (only 72), and frankly, I think discussing
>the commit or comment line length is pretty useless.

You are the only one not using 72 chars for some undefined reasons. 
But in patch 3/5 you actually do. Sorry but that is just weird.
All I'm saying.
