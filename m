Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bugs.comnets.uni-bremen.de ([134.102.186.10]:53533 "EHLO
	bugs.comnets.uni-bremen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbYENNIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 09:08:15 -0400
Date: Wed, 14 May 2008 15:08:13 +0200 (CEST)
From: Markus Becker <mab@comnets.uni-bremen.de>
To: Pavel Roskin <proski@gnu.org>
cc: John Daiker <daikerjohn@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: First patch to mrv8k driver?
In-Reply-To: <1210739857.2721.51.camel@rd>
Message-ID: <Pine.LNX.4.64.0805141506000.24384@bugs.comnets.uni-bremen.de> (sfid-20080514_150818_666387_341BD5DB)
References: <482A3961.2010906@gmail.com> <1210739857.2721.51.camel@rd>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 14 May 2008, Pavel Roskin wrote:

> On Tue, 2008-05-13 at 17:59 -0700, John Daiker wrote:
>> Hey All,
>>
>> My first patch for the mrv8k driver.  My machine locks up when I try to
>> load a firmware, so I'm not sure if this patch helps anybody or not.
>
> I don't see any changes for mrv_reg_read32() claimed in the description.

He is checking the return value to 0x5 instead of 5.

> In fact, I don't see any changes to the code except comments and
> messages.  I don't see how it can help against lockups, unless you
> missed some part of the patch.

It does not. But I pushed the comment and indent fixes to mrv8k 
nevertheless.

> You may want to spell check your patch, including the description,
> especially if the patch is fixing spelling mistakes made by others.
>
> -- 
> Regards,
> Pavel Roskin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
