Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab1HHQcn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 12:32:43 -0400
Date: Mon, 8 Aug 2011 09:32:32 -0700
From: Greg KH <gregkh@suse.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: Dan Carpenter <error27@gmail.com>,
	"sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 00/82] staging: brcm80211: resubmit previously posted
 patches
Message-ID: <20110808163232.GA26352@suse.de> (sfid-20110808_183246_906626_71177680)
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
 <CA+icZUUBokLgtn3K3uG7qcNLzy4pfdT4fGYWPtoOy_MQVy8VuA@mail.gmail.com>
 <20110808145334.GA7659@shale.localdomain>
 <4E400A92.7060905@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E400A92.7060905@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 08, 2011 at 06:10:58PM +0200, Arend van Spriel wrote:
> On 08/08/2011 04:53 PM, Dan Carpenter wrote:
> >On Mon, Aug 08, 2011 at 04:29:49PM +0200, Sedat Dilek wrote:
> >>2. Using "staging/brcm80211" would also save some chars (and is more
> >>common to me).
> >No one would complain if the prefix were "staging/brcm80211" but
> >actually the way Arend has it is prefered.
> >
> >git log --pretty=oneline --author=gregkh drivers/staging/
> 
> Nice. Learning something today about --author filter.
> >>3. "PATCH v2" should be with a space?
> >git am doesn't care.  It strips everything out correctly.
> >
> >>4. Something like "for-3.1" would clearly indicate for which
> >>kernel-release this mega-series is for (also "staging" could be
> >>dropped as it is known where the driver is managed)
> >>
> >>$ git format-patch --signoff --cover-letter --subject-prefix="PATCH v2
> >>for-3.1" -82 (or whatever $FIRST..$LAST)
> 
> I actually would think this all is for 3.2 as 3.1 has already been
> merged hence 3.1-rc1 and only bug fixes are to be merged into 3.1.
> 
> >Everything was explained in the cover letter, so I think it's ok.
> >
> >regards,
> >dan carpenter
> 
> Thanks. I leave it as it is unless Greg sees good reasons to change
> any conventions here.

No, as you sent it is fine with me.

I'll start going through the huge backlog of staging patches this week,
as the merge window just opened up a few hours ago.

thanks,

greg k-h
