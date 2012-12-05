Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:45839 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2LELHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 06:07:40 -0500
Received: by mail-ie0-f171.google.com with SMTP id 17so9280909iea.16
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 03:07:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354699072.9972.7.camel@jlt4.sipsolutions.net>
References: <CABPxzYKrYPo9S-t6dSPS3qgwKcsaD=uoiAm2+naS7C6D=3KBOg@mail.gmail.com>
 <1354699072.9972.7.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 5 Dec 2012 16:37:19 +0530
Message-ID: <CABPxzYKwA99yXhVR52L1UD=EGNNCotuR94d5pjfhOpnUj_G1DA@mail.gmail.com> (sfid-20121205_120743_948687_367AAF70)
Subject: Re: [PATCH] mac80211: fixing the warning storm for budding chipsets
 without ampdu_action defined
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have verified the patch with the checkpatch.pl, i think the
whitespace got introduced when i copied the patch from the file to
mail.
The Mail editor (gmail/thunderbird) automatically converts all tabs to spaces.

What should be the ideal settings for VIM editor and lets say gmail/thunderbird.

for VIM i have done:

set tabstop=4
set shiftwidth=4
set expandtab

Is there any thing extra i need to do? a little newbie help would be great :-)

On Wed, Dec 5, 2012 at 2:47 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2012-12-05 at 14:43 +0530, Krishna Chaitanya wrote:
>> Warn once should suffice.
>
> Indeed :)
>
>> Eg: our driver doesn't support the ampdu_action yet, so
>> seeing a lot of warnings, hence the check for any
>> new drivers to avoid messing the kernel log.
>
> Please make the subject active voice ("fix the warning storm [...]").
>
> Your patches are all whitespace damaged.
>
> $ git am -s /tmp/\[PATCH\]_mac80211\:_fixing_the_warning_storm_for_budding_chipsets_without_ampdu_action_defined.mbox
> Applying: mac80211: fixing the warning storm for budding chipsets without ampdu_action defined
> fatal: corrupt patch at line 10
> Patch failed at 0001 mac80211: fixing the warning storm for budding chipsets without ampdu_action defined
> The copy of the patch that failed is found in:
>    /home/johannes/sys/wireless/.git/rebase-apply/patch
> When you have resolved this problem, run "git am --resolved".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
>
> johannes
>
