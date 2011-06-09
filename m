Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37635 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757849Ab1FINXh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 09:23:37 -0400
To: Dan Carpenter <error27@gmail.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath6kl: fix crash when interface is closed but scan is ongoing
References: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
	<20110608115501.32208.82264.stgit@localhost6.localdomain6>
	<20110608200332.GC4069@shale.localdomain>
	<20110608201458.GD4069@shale.localdomain>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 09 Jun 2011 16:23:36 +0300
In-Reply-To: <20110608201458.GD4069@shale.localdomain> (Dan Carpenter's message of "Wed\, 8 Jun 2011 23\:14\:58 +0300")
Message-ID: <87sjrj6svb.fsf@purkki.adurom.net> (sfid-20110609_152347_576090_401D2A3E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <error27@gmail.com> writes:

> On Wed, Jun 08, 2011 at 11:03:32PM +0300, Dan Carpenter wrote:
>> On Wed, Jun 08, 2011 at 02:55:01PM +0300, Kalle Valo wrote:
>> > -        /* Translate data to cfg80211 mgmt format */
>> > -	if (ar->arWmi)
>>             ^^^^^^^^^
>> 	You removed this check on purpose?  Is this only NULL when
>> 	the scan is canceled?
>
> Grr...  That's the check that was just added in [PATCH 4/4] of this
> exact same series!  Seriously?  Why are we submitting known wrong
> patches???

I only combined the pending ath6kl patches, I did not edit them.
Vasanth sent patch 4 few days earlier and that's why you see the
change here. But if greg wants, I can drop patch 4 and resend the
series.

But now that you mention this, I realise that my sob line is missing
from patch 4 as well.

-- 
Kalle Valo
