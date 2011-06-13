Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:55966 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab1FMHtg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 03:49:36 -0400
To: Dan Carpenter <error27@gmail.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] ath6kl: cache firmware
References: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
	<20110608115440.32208.75072.stgit@localhost6.localdomain6>
	<20110608194031.GA4069@shale.localdomain>
	<871uz387ut.fsf@purkki.adurom.net>
	<20110609154241.GI4069@shale.localdomain>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 13 Jun 2011 10:49:32 +0300
In-Reply-To: <20110609154241.GI4069@shale.localdomain> (Dan Carpenter's message of "Thu\, 9 Jun 2011 18\:42\:41 +0300")
Message-ID: <87k4cq6uib.fsf@purkki.adurom.net> (sfid-20110613_094939_669815_C15A2D6F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <error27@gmail.com> writes:

>> >> +    if (*buf == NULL) {
>> >> +	    if ((A_REQUEST_FIRMWARE(&fw_entry, filename, ((struct device *)ar->osDevInfo.pOSDevice))) != 0)
>> >> +	    {
>> >             ^
>> >
>> > This is on the wrong line.
>> 
>> I'll answer this and all the other style comments in one go:
>> 
>> All the style issues are from the original code. I want to separate
>> functional and cleanup patches so I didn't do any cleanup in this
>> patch. But as we are doing the cleanup in a different tree anyway I
>> didn't see the point of sending a separate cleanup patch.
>> 
>
> No.  That was in a section of code which was added.  There wasn't
> a "buf" variable in the original code.  You obviously know how it's
> supposed to look because you did it correctly on the line before.

Oh, you are right. Sorry about that, I'll fix that in v2.

-- 
Kalle Valo
