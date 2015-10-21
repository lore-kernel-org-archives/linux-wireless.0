Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbbJUA3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 20:29:08 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 00/16] rtl8xxxu: eFUSE parsing for RTL8188EU chips
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
Date: Tue, 20 Oct 2015 20:29:06 -0400
In-Reply-To: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com> (Jakub
	Sitnicki's message of "Tue, 20 Oct 2015 08:45:30 +0200")
Message-ID: <wrfjeggpxdwt.fsf@redhat.com> (sfid-20151021_022913_707665_4903B80C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Sitnicki <jsitnicki@gmail.com> writes:
> Hi Jes,
>
> I'm posting this patch set to show in what direction the work is
> going.  Hopefully any changes (e.g. renames) which you wouldn't see
> fit for this driver can be identified early this way.
>
> The work is nowhere near the end.  These changes only get me past the
> parse_efuse() step in the probe() routine.
>
> I've structured the patch set in such a way that changes that are not
> RTL8188EU-specific (preparatory work) come first.  All but the last
> two patches (tagged "rtl8188eu:") fall into this category.  If you
> were considering to apply any of them, note that they were not tested
> with any device that is known to work with rtl8xxxu, only a TP-Link
> TL-WN725N (RTL8188EU) dongle.
>
> The corresponding git branch for this patch set is at:
>
> git https://github.com/jsitnicki/linux.git branch rtl8xxxu-rtl8188eu

Jakub,

Thanks for the feedback - some of these patches are good, some of them I
dislike, and some of them will conflict with work I have been doing
since I posted the patch. I have been working on adding 8723bu and
8192eu support and some of those changes should also benefit your work.

I have pushed my current nextgen tree to git, so if you checkout the
rtl8xxxu-nextgen branch you will see it.

I'll respond to the individual patches here.

Cheers,
Jes
