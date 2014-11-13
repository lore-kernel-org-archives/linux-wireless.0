Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:55420 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaKMP4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 10:56:22 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so6439515wgg.21
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2014 07:56:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XsD+wcTZSX7oZKK72fQjMV0r_TOTeUfGOg8Oh9bHsnLg@mail.gmail.com>
References: <1414046257-22184-1-git-send-email-arik@wizery.com>
 <CAB=NE6XbFC1aRAMOQZUTPKRbH4XeBnzpZv7-A3oREoo17mUPtQ@mail.gmail.com>
 <CA+XVXfdxT=5ch7VwZu3ntJ14jMBD0DTod5+1Y+95eDG8H2Je+Q@mail.gmail.com> <CAB=NE6XsD+wcTZSX7oZKK72fQjMV0r_TOTeUfGOg8Oh9bHsnLg@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 13 Nov 2014 17:56:04 +0200
Message-ID: <CA+XVXfcEM2b3eH3d6tnrydtVOKuMyUG2hoUKQUfzq3feFnFcOQ@mail.gmail.com> (sfid-20141113_165625_982210_6C0EB1A0)
Subject: Re: [PATCH 0/5] wiphy-specific regulatory management
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 13, 2014 at 1:07 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Wed, Nov 5, 2014 at 12:41 AM, Arik Nemtsov <arik@wizery.com> wrote:
>> On Wed, Nov 5, 2014 at 5:21 AM, Luis R. Rodriguez
>> <mcgrof@do-not-panic.com> wrote:
>>> On Wed, Oct 22, 2014 at 11:37 PM, Arik Nemtsov <arik@wizery.com> wrote:
>>>>   cfg80211: allow wiphy specific regdomain management
>>>
>>> This guy never made it to my inbox.
>>
>> Here it is:
>> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/129448
>
> Look OK but I can't comment on code so please also Cc this address on
> future patches: mcgrof@suse.com. Look forward to next iteration.

I'll resubmit the v2 with the pr_info change, so you'll be able to
comment on the missing patch.

Arik
