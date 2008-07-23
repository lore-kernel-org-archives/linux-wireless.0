Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gw.goop.org ([64.81.55.164]:39086 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbYGWWY6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 18:24:58 -0400
Message-ID: <4887AFB6.2060802@goop.org> (sfid-20080724_002502_733928_13CAFD11)
Date: Wed, 23 Jul 2008 15:24:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, yi.zhu@intel.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Potential iwlwifi locking problem in 2.6.26-git9
References: <E1KLm0c-0002O6-RO@closure.thunk.org> <20080723214938.GA8034@mit.edu>
In-Reply-To: <20080723214938.GA8034@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Jul 23, 2008 at 05:36:30PM -0400, Theodore Ts'o wrote:
>   
>> Is this a new one?  I don't think I've seen this on LKML....
>>     
>
> The context of this was I had just booted to 2.6.26-git9, noted with
> annoyance that that the iwl4965 driver needed a new microcode file, so
> I popped in my EVDO card, downloaded the firmware, moved the firmware
> into place, and then got the above error message.
>
> I've since noted that it seems to be utterly refusing to associate
> with my wireless access point.  This was working just fine with
> 2.6.26-git6 kernel, so it looks like a recent regression?  I just
> noticed someone else had recently complained about a similar "refusal
> to associate" with the iwl3945 driver.
>   

I noticed the same thing last night; a current git build goes through 
all the motions, but then fails to associate.

    J
