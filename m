Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59524 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab1FDAzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 20:55:01 -0400
Received: by iwn34 with SMTP id 34so1797601iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2011 17:55:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE912BA.6060805@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <BANLkTi=Mwbm_yrtL1u8mNboXdYYQz2HbDQ@mail.gmail.com> <4DE912BA.6060805@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 4 Jun 2011 10:54:41 +1000
Message-ID: <BANLkTikdfC+OTGUDV35_M_ka67Q1u=jbbQ@mail.gmail.com> (sfid-20110604_025508_426684_B4B555D0)
Subject: Re: [PATCH 01/83] staging: brcm80211: removed unused Broadcom
 specific ioctls codes
To: Roland Vossen <rvossen@broadcom.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 4, 2011 at 02:58, Roland Vossen <rvossen@broadcom.com> wrote:
> On 06/02/2011 05:06 AM, Julian Calaby wrote:
>>
>> Roland,
>>
>> I've passed an eye over the entire patch set.
>>
>> My comments are pretty minor, but I've replied to the patches that I
>> have concerns for. Please note that I'm not really a developer, and my
>> comments are mostly style issues, not actual functional issues. Oh,
>> and also, I read most of the patches out of order, so some of the
>> comments may not make complete sense.
>>
>> Overall, my comments are these:
>> 1. If you're doing typedef removals in a patch, mention it in the summary.
>> 2. Work on your summaries, there are a few cases where I think they're
>> a little too terse.
>> 3. Good work!
>> 4. Keep going =)
>
> Thanks ! Your comments are noted. Btw, this patch train is not just the
> fruit of my labor, so Arend and Franky deserve this credit as well :-)

Of course! I was addressing you as you posted them to the list.

>> 3. Do a typedef removal sweep over the code because typedefs are ugly =)
>
> Agree. At the end of the patch train, all typedefs have been moved over to
> one file. Next step is to get rid of them.

Cool!

>> 4. I had a glance at /Documentation/CodingStyle and saw that there
>> were some issues mentioned in there that could be fixed in your code.
>> You might also want to play with checkpatch.
>
> When writing new code, we adhere to checkpatch. But in these patches, a lot
> of (existing) code was moved around. We could have placed a separate commit
> after each move that fixed up checkpatch issues (not in the same commit
> since that blocks tools from detecting the movement of code), but at the
> moment the focus is on structural code cleanup (reducing number of .c and .h
> files, removing dead code, etc).

Fair enough, was just pointing it out.

>> I'm probably missing a whole lot of other, much more important, stuff,
>> but this is what I saw.
>
> Valuable feedback, taken into account. Thanks for investing time in this.

No problem, I try to pass my eye over all patches that make their way
through the list, particularly if they're for drivers I care about.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
