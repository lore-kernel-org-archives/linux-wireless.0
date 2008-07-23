Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:35993 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYGWWCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 18:02:16 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1156810ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 15:02:15 -0700 (PDT)
Message-ID: <1ba2fa240807231502t1c4ce7d5k9b8acbcaed4d166a@mail.gmail.com> (sfid-20080724_000221_248296_BD9E52A9)
Date: Thu, 24 Jul 2008 01:02:15 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, yi.zhu@intel.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Potential iwlwifi locking problem in 2.6.26-git9
In-Reply-To: <20080723214938.GA8034@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <E1KLm0c-0002O6-RO@closure.thunk.org>
	 <20080723214938.GA8034@mit.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 24, 2008 at 12:49 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Jul 23, 2008 at 05:36:30PM -0400, Theodore Ts'o wrote:
>>
>> Is this a new one?  I don't think I've seen this on LKML....
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

I'm not sure but this can be connected to what is described in thread:
'New: dhcp doesn't work with iwl4965'
Tomas
