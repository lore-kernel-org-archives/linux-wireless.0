Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61180 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759290Ab1FBDGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 23:06:54 -0400
Received: by iyb14 with SMTP id 14so336610iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 20:06:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 2 Jun 2011 13:06:33 +1000
Message-ID: <BANLkTi=Mwbm_yrtL1u8mNboXdYYQz2HbDQ@mail.gmail.com> (sfid-20110602_050708_235074_E6FA5942)
Subject: Re: [PATCH 01/83] staging: brcm80211: removed unused Broadcom
 specific ioctls codes
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Roland,

I've passed an eye over the entire patch set.

My comments are pretty minor, but I've replied to the patches that I
have concerns for. Please note that I'm not really a developer, and my
comments are mostly style issues, not actual functional issues. Oh,
and also, I read most of the patches out of order, so some of the
comments may not make complete sense.

Overall, my comments are these:
1. If you're doing typedef removals in a patch, mention it in the summary.
2. Work on your summaries, there are a few cases where I think they're
a little too terse.
3. Good work!
4. Keep going =)

A couple of items you might want to add to your TODO list:
1. Replace the REG_[RW] macros with inline functions or equivalent
because they're ugly.
2. You shouldn't need to #ifdef on BIG_ENDIAN - there are a set of
macros to help with working with different endian systems.
3. Do a typedef removal sweep over the code because typedefs are ugly =)
4. I had a glance at /Documentation/CodingStyle and saw that there
were some issues mentioned in there that could be fixed in your code.
You might also want to play with checkpatch.
5. Personally, I'd avoid void pointers, but I'm not sure of the exact
rules. Could someone else weigh in on this?

I'm probably missing a whole lot of other, much more important, stuff,
but this is what I saw.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
