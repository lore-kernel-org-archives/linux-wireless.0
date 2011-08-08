Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2492 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740Ab1HHQLO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 12:11:14 -0400
Message-ID: <4E400A92.7060905@broadcom.com> (sfid-20110808_181117_484253_F9319269)
Date: Mon, 8 Aug 2011 18:10:58 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <error27@gmail.com>
cc: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 00/82] staging: brcm80211: resubmit previously
 posted patches
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
 <CA+icZUUBokLgtn3K3uG7qcNLzy4pfdT4fGYWPtoOy_MQVy8VuA@mail.gmail.com>
 <20110808145334.GA7659@shale.localdomain>
In-Reply-To: <20110808145334.GA7659@shale.localdomain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/2011 04:53 PM, Dan Carpenter wrote:
> On Mon, Aug 08, 2011 at 04:29:49PM +0200, Sedat Dilek wrote:
>> 2. Using "staging/brcm80211" would also save some chars (and is more
>> common to me).
> No one would complain if the prefix were "staging/brcm80211" but
> actually the way Arend has it is prefered.
>
> git log --pretty=oneline --author=gregkh drivers/staging/

Nice. Learning something today about --author filter.
>> 3. "PATCH v2" should be with a space?
> git am doesn't care.  It strips everything out correctly.
>
>> 4. Something like "for-3.1" would clearly indicate for which
>> kernel-release this mega-series is for (also "staging" could be
>> dropped as it is known where the driver is managed)
>>
>> $ git format-patch --signoff --cover-letter --subject-prefix="PATCH v2
>> for-3.1" -82 (or whatever $FIRST..$LAST)

I actually would think this all is for 3.2 as 3.1 has already been 
merged hence 3.1-rc1 and only bug fixes are to be merged into 3.1.

> Everything was explained in the cover letter, so I think it's ok.
>
> regards,
> dan carpenter

Thanks. I leave it as it is unless Greg sees good reasons to change any 
conventions here.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


