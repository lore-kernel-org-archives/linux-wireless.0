Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2196 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab1FCREx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 13:04:53 -0400
Message-ID: <4DE91429.9090903@broadcom.com> (sfid-20110603_190500_472211_0651CEC1)
Date: Fri, 3 Jun 2011 10:04:41 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
MIME-Version: 1.0
To: "Julian Calaby" <julian.calaby@gmail.com>
cc: "Roland Vossen" <rvossen@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH 01/83] staging: brcm80211: removed unused Broadcom
 specific ioctls codes
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <BANLkTi=Mwbm_yrtL1u8mNboXdYYQz2HbDQ@mail.gmail.com>
In-Reply-To: <BANLkTi=Mwbm_yrtL1u8mNboXdYYQz2HbDQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/01/2011 08:06 PM, Julian Calaby wrote:
> Roland,
>
> I've passed an eye over the entire patch set.

Thanks for taking the time and putting in the effort to reveiw them all.

> My comments are pretty minor, but I've replied to the patches that I
> have concerns for. Please note that I'm not really a developer, and my
> comments are mostly style issues, not actual functional issues. Oh,
> and also, I read most of the patches out of order, so some of the
> comments may not make complete sense.
>
> Overall, my comments are these:
> 1. If you're doing typedef removals in a patch, mention it in the summary.

Will do.

> 2. Work on your summaries, there are a few cases where I think they're
> a little too terse.

Ditto.

> 3. Good work!

Thanks!

> 4. Keep going =)

We definitely will.

> A couple of items you might want to add to your TODO list:
> 1. Replace the REG_[RW] macros with inline functions or equivalent
> because they're ugly.

Agree that they're ugly.  Still working on how exactly to clean them up, 
but we'll get there eventually.

> 2. You shouldn't need to #ifdef on BIG_ENDIAN - there are a set of
> macros to help with working with different endian systems.

Any specific ones we should be looking at?

> 3. Do a typedef removal sweep over the code because typedefs are ugly =)

Definitely on the list of cleanup.

> 4. I had a glance at /Documentation/CodingStyle and saw that there
> were some issues mentioned in there that could be fixed in your code.
> You might also want to play with checkpatch.

A few of the patches have complaints from checkpatch, but I believe that 
in all cases the complaints are on existing code that's being moved from 
one file to another to help consolidate things.  We'll keep working on 
cleaning up those issues as we go along.

Any specific checkpatch issues in this series that we should take a 
second look at?

> 5. Personally, I'd avoid void pointers, but I'm not sure of the exact
> rules. Could someone else weigh in on this?
>
> I'm probably missing a whole lot of other, much more important, stuff,
> but this is what I saw.

Thanks again for all the effort.

At this point, should we regenerate the whole series to try and address 
your concerns, or should we do the additional cleanup as followup patches?

Thanks,
- Henry

