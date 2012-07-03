Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:35590 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab2GCQag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:30:36 -0400
Received: by ghrr11 with SMTP id r11so5484391ghr.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 09:30:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341332487.20124.7.camel@jlt3.sipsolutions.net>
References: <1341322108.20124.3.camel@jlt3.sipsolutions.net>
 <CAB=NE6VvJ+rv4mtYMngVg==tDVZpRM2CrGJ3Yc4u7a7ZLwiGOA@mail.gmail.com>
 <CAB=NE6WDyFS5gK85Lq1uEA5A5HLRhhyVcFT7EQkK0SALG0YF6g@mail.gmail.com> <1341332487.20124.7.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 3 Jul 2012 09:30:14 -0700
Message-ID: <CAB=NE6UWtcBKt6_et0Fn7wr1xZ4g-1O3OHo25PEdffjJd7AdHA@mail.gmail.com> (sfid-20120703_183039_323043_7AB49713)
Subject: Re: [PATCH] compat-wireless: fix debugging in iwlwifi
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 3, 2012 at 9:21 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2012-07-03 at 09:16 -0700, Luis R. Rodriguez wrote:
>> On Tue, Jul 3, 2012 at 8:47 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> > On Tue, Jul 3, 2012 at 6:28 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> >> From: Johannes Berg <johannes.berg@intel.com>
>> >>
>> >> As compat includes linux/device.h well before iwlwifi, the
>> >> definitions from there are used without DEBUG, but iwlwifi
>> >> defines DEBUG to get debug output. Use dev_printk instead
>> >> of dev_dbg to get debugging back.
>> >>
>> >> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> >
>> > Applied and pushed, thanks!
>>
>> On today's linux-next.git the dev_dbg() changed to dev_err(), I've
>> updated the patch to reflect this.
>
> Huh, sorry. Please drop this for now -- the patch to change it *from*
> dev_err *to* dev_dbg is only in my iwlwifi-next tree now.

Dropped patches/57-iwlwifi-debug-fix.patch

  Luis
