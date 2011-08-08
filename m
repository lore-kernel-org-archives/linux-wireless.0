Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51432 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab1HHOzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 10:55:45 -0400
Received: by pzk37 with SMTP id 37so8427476pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 07:55:44 -0700 (PDT)
Date: Mon, 8 Aug 2011 17:53:34 +0300
From: Dan Carpenter <error27@gmail.com>
To: sedat.dilek@gmail.com
Cc: Arend van Spriel <arend@broadcom.com>,
	devel@linuxdriverproject.org, gregkh@suse.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 00/82] staging: brcm80211: resubmit previously posted
 patches
Message-ID: <20110808145334.GA7659@shale.localdomain> (sfid-20110808_165551_159799_58102AFF)
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
 <CA+icZUUBokLgtn3K3uG7qcNLzy4pfdT4fGYWPtoOy_MQVy8VuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+icZUUBokLgtn3K3uG7qcNLzy4pfdT4fGYWPtoOy_MQVy8VuA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 08, 2011 at 04:29:49PM +0200, Sedat Dilek wrote:
>
> 1. Drop "staging" from subject-lines? Saves some chars.

The Staging is required for staging code.

> 2. Using "staging/brcm80211" would also save some chars (and is more
> common to me).

No one would complain if the prefix were "staging/brcm80211" but
actually the way Arend has it is prefered.

git log --pretty=oneline --author=gregkh drivers/staging/

> 3. "PATCH v2" should be with a space?

git am doesn't care.  It strips everything out correctly.

> 4. Something like "for-3.1" would clearly indicate for which
> kernel-release this mega-series is for (also "staging" could be
> dropped as it is known where the driver is managed)
> 
> $ git format-patch --signoff --cover-letter --subject-prefix="PATCH v2
> for-3.1" -82 (or whatever $FIRST..$LAST)

Everything was explained in the cover letter, so I think it's ok.

regards,
dan carpenter
