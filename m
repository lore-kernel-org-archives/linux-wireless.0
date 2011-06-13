Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58081 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab1FMIDj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 04:03:39 -0400
To: Dan Carpenter <error27@gmail.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org, vasanth@atheros.com
Subject: Re: [PATCH 5/5] ath6kl: fix crash when interface is closed but scan is ongoing
References: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
	<20110608115501.32208.82264.stgit@localhost6.localdomain6>
	<20110608200332.GC4069@shale.localdomain>
	<20110608201458.GD4069@shale.localdomain>
	<87sjrj6svb.fsf@purkki.adurom.net>
	<20110609152453.GH4069@shale.localdomain>
	<87fwne6uda.fsf@purkki.adurom.net>
	<20110613075533.GD3583@shale.localdomain>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 13 Jun 2011 11:03:37 +0300
In-Reply-To: <20110613075533.GD3583@shale.localdomain> (Dan Carpenter's message of "Mon\, 13 Jun 2011 10\:55\:33 +0300")
Message-ID: <87boy26tuu.fsf@purkki.adurom.net> (sfid-20110613_100344_221219_79EAAB7A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <error27@gmail.com> writes:

> On Mon, Jun 13, 2011 at 10:52:33AM +0300, Kalle Valo wrote:
>> Dan Carpenter <error27@gmail.com> writes:
>> 
>> > On Thu, Jun 09, 2011 at 04:23:36PM +0300, Kalle Valo wrote:
>> >> I only combined the pending ath6kl patches, I did not edit them.
>> >> Vasanth sent patch 4 few days earlier and that's why you see the
>> >> change here. But if greg wants, I can drop patch 4 and resend the
>> >> series.
>> >
>> > Part of the problem is that patch doesn't add the check for NULL
>> > consistently throughout the function.  There is a place where a NULL
>> > deref could still be triggered later on.  Let's just drop it instead
>> > of fixing it.
>> 
>> Agreed.
>> 
>> But I see that Greg applied the patch 4 already. So I just drop patch
>> 4 from my patchset and resend patch 5 as is (ie. removing the
>> unnecessary null check).
>
> Yep.  It really should go the 3.0 kernel along with [PATCH 3/5]
> ath6kl: cache firmware.

Thanks, I'll mention this in the cover letter. I'll also change the
order of patches so that the most important patches are first.

Thanks for all the review and help.

-- 
Kalle Valo
