Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kmu-office.ch ([178.209.48.109]:53323 "EHLO
        mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S946378AbdDTOVv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 10:21:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Thu, 20 Apr 2017 07:21:40 -0700
From: Stefan Agner <stefan@agner.ch>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nl80211: fix enumeration type
In-Reply-To: <1492672926.3109.5.camel@sipsolutions.net>
References: <20170420065513.1930-1-stefan@agner.ch>
 <1492672926.3109.5.camel@sipsolutions.net>
Message-ID: <cbdee27002a2f285221bb83af835430a@agner.ch> (sfid-20170420_162155_632688_F8759549)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-04-20 00:22, Johannes Berg wrote:
> On Wed, 2017-04-19 at 23:55 -0700, Stefan Agner wrote:
>> Use type enum nl80211_rate_info for bitrate information. This fixes
>> a warning when compiling with clang:
>>   warning: implicit conversion from enumeration type 'enum
>> nl80211_rate_info'
>>   to different enumeration type 'enum nl80211_attrs'
> 
> I'm pretty sure I just applied exactly these two patches very recently.
> 
> What made *two* people suddenly see this?

There has been renewed work on compiling Linux using clang... Sorry for
the clash.

--
Stefan
