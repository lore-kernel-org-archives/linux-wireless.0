Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:34244 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbbJWFYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:24:44 -0400
Received: by lfaz124 with SMTP id z124so71378438lfa.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2015 22:24:43 -0700 (PDT)
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com> <wrfjeggpxdwt.fsf@redhat.com>
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 00/16] rtl8xxxu: eFUSE parsing for RTL8188EU chips
In-reply-to: <wrfjeggpxdwt.fsf@redhat.com>
Date: Fri, 23 Oct 2015 07:24:41 +0200
Message-ID: <8737x2taw6.fsf@frog.home> (sfid-20151023_072447_926991_DD55E234)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 21, 2015 at 02:29 AM CEST, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Jakub Sitnicki <jsitnicki@gmail.com> writes:
>> Hi Jes,
>>
>> I'm posting this patch set to show in what direction the work is
>> going.  Hopefully any changes (e.g. renames) which you wouldn't see
>> fit for this driver can be identified early this way.
>>
>> The work is nowhere near the end.  These changes only get me past the
>> parse_efuse() step in the probe() routine.
>>
>> I've structured the patch set in such a way that changes that are not
>> RTL8188EU-specific (preparatory work) come first.  All but the last
>> two patches (tagged "rtl8188eu:") fall into this category.  If you
>> were considering to apply any of them, note that they were not tested
>> with any device that is known to work with rtl8xxxu, only a TP-Link
>> TL-WN725N (RTL8188EU) dongle.
>>
>> The corresponding git branch for this patch set is at:
>>
>> git https://github.com/jsitnicki/linux.git branch rtl8xxxu-rtl8188eu
>
> Jakub,
>
> Thanks for the feedback - some of these patches are good, some of them I
> dislike, and some of them will conflict with work I have been doing
> since I posted the patch. I have been working on adding 8723bu and
> 8192eu support and some of those changes should also benefit your work.
>
> I have pushed my current nextgen tree to git, so if you checkout the
> rtl8xxxu-nextgen branch you will see it.
>
> I'll respond to the individual patches here.

Thanks for the prompt review and the feedback.  I'll rebase the
RTL8188EU-related patches onto the -nextgen branch, and will be watching
it.

Cheers,
Jakub

