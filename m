Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39610 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2LGU0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 15:26:07 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so363156wey.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 12:26:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354791010.10150.1.camel@jlt4.sipsolutions.net>
References: <1354745174-2941-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
 <CAG6hwVOc=E67ZxuFZnk3goM8VVEOqSWOi6dn63L2rmEyWOfG1g@mail.gmail.com> <1354791010.10150.1.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 7 Dec 2012 12:25:44 -0800
Message-ID: <CAG6hwVMkhScnykjjzzDExo_vcPUWcAopZQn4s8rjC_6LH4g58w@mail.gmail.com> (sfid-20121207_212612_095835_3CE7B240)
Subject: Re: [PATCH] {nl, cfg, mac}80211: set beacon interval and DTIM period
 on mesh join
To: Johannes Berg <johannes@sipsolutions.net>
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 2:50 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2012-12-05 at 14:57 -0800, Thomas Pedersen wrote:
>> On Wed, Dec 5, 2012 at 2:06 PM, Marco Porsch
>> <marco.porsch@etit.tu-chemnitz.de> wrote:
>> > Move the default mesh beacon interval and DTIM period to cfg80211 and
>> > make it accessible to nl80211. This enables setting both values when joining
>> > an MBSS.
>> >
>> > NOTE: In a mesh with links in PS mode it is not advised to use the default
>> > parameters 1000:4, as these cause excessive buffering delays that exceed
>> > various timeouts (e.g. HWMP path request).
>>
>> Then make the default parameters reasonable? How is 1000:2?
>
> That's still ~2 seconds, no?

Yeah I guess those would both be unsuitable for PS anyway, so it's fine as is.

Thomas
