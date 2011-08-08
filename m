Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46819 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab1HHO3u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 10:29:50 -0400
Received: by qwk3 with SMTP id 3so765105qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 07:29:49 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
Date: Mon, 8 Aug 2011 16:29:49 +0200
Message-ID: <CA+icZUUBokLgtn3K3uG7qcNLzy4pfdT4fGYWPtoOy_MQVy8VuA@mail.gmail.com> (sfid-20110808_162953_434712_E00E4E23)
Subject: Re: [PATCHv2 00/82] staging: brcm80211: resubmit previously posted patches
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 8, 2011 at 3:57 PM, Arend van Spriel <arend@broadcom.com> wrote:
> Before and during the 3.1 merge window three patch series were posted. Feedback
> from Dan Carpenter learned that some of the patches did not apply after 3.1
> merges. Therefor the series are resubmitted here with some changes as described
> below.
>
> [PATCHv2 01/82] fixes a compilation error due to missing <linux/io.h> include
> since 3.1-rc1.
>
> Series "[PATCH 00/35] staging: brcm80211: code cleanup and bugfix":
>  [PATCH 17/35] has been merged with later patch to remove checkpatch warning.
>  [PATCH 33/35] was removed as it caused regression for brcmfmac driver.
>
> Series "[PATCH 00/19] checkpatch changes and brcmfmac cleanup"
>  Resubmitted as before.
>
> Series "[PATCH 00/29] staging: brcm80211: cleanup checkpatch warnings"
>  [PATCH 09/29] has been rephrased to apropriately describe what changed.
>  [PATCH 13/29] was merged with [PATCH 17/35] from the first series.
>
> [PATCHv2 80/82] fixes a compiler warning for ARM platform since 3.1-rc1.
>
> Arend Van Spriel (1):
>  staging: brcm80211: fix compile error on non-x86 archs since 3.0
>    kernel
>

Personally, I have no broadcom wifi-card.

First of all, it won't hurt to add some URLs (for example <marc.info>)
for your previous postings, so interested people can easily follow.

Just some suggestions for subject-prefix:

1. Drop "staging" from subject-lines? Saves some chars.
2. Using "staging/brcm80211" would also save some chars (and is more
common to me).
3. "PATCH v2" should be with a space?
4. Something like "for-3.1" would clearly indicate for which
kernel-release this mega-series is for (also "staging" could be
dropped as it is known where the driver is managed)

$ git format-patch --signoff --cover-letter --subject-prefix="PATCH v2
for-3.1" -82 (or whatever $FIRST..$LAST)

- Sedat -
