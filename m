Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:65045 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZIYU5y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 16:57:54 -0400
Received: by ewy7 with SMTP id 7so2916824ewy.17
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 13:57:57 -0700 (PDT)
Message-ID: <4ABD2ECE.50501@gmail.com>
Date: Fri, 25 Sep 2009 21:57:50 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Matthew Ryan <rudicus@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Porting AR6K to use cfg80211
References: <loom.20090925T193922-290@post.gmane.org> <200909252005.23746.mb@bu3sch.de> <loom.20090925T222532-791@post.gmane.org>
In-Reply-To: <loom.20090925T222532-791@post.gmane.org>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthew Ryan wrote:
> Michael Buesch <mb@...> writes:
>> On Friday 25 September 2009 19:40:52 Matthew Ryan wrote:
>>> I was curious if I could get a few expert opinions on if its possible to port
>>> this driver to use mac80211, and how difficult/ what pitfalls there may be.
>> The device is fullmac, so it does not require mac80211.
>> I guess however, ar6k can be ported to use cfg80211.
>>
> 
> Do you know of any examples in the source tree which are fullmac, but utilize
> cfg80211 that I could use as a base to get started?

There are a few fullmac drivers in wireless-testing that use cfg80211. I
don't think these are in the recently released 2.6.31, but are queued
for 2.6.32.

iwmc3200wifi and rndis_wlan are furthest along. orinoco is in the
process of conversion (it uses cfg80211, but relies on the wext
compatibility code for a large portion of functionality).


Dave.
