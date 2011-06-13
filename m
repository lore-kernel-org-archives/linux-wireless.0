Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:47436 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab1FMIVr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 04:21:47 -0400
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
	<87boy26tuu.fsf@purkki.adurom.net>
	<20110613081816.GE3583@shale.localdomain>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 13 Jun 2011 11:21:42 +0300
In-Reply-To: <20110613081816.GE3583@shale.localdomain> (Dan Carpenter's message of "Mon\, 13 Jun 2011 11\:18\:16 +0300")
Message-ID: <874o3u6t0p.fsf@purkki.adurom.net> (sfid-20110613_102150_785533_F67A8193)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <error27@gmail.com> writes:

> On Mon, Jun 13, 2011 at 11:03:37AM +0300, Kalle Valo wrote:
>> Thanks, I'll mention this in the cover letter. I'll also change the
>> order of patches so that the most important patches are first.
>> 
>
> Greg could say for sure, but sometimes it helps to break it up into
> two separate patch sets.  When you're applying them, you just tag
> all the messages in the thread and apply them with one command.
>
> [PATCH 0/2] fix crashes for 3.0
> [PATCH 0/2] new stuff for 3.1  (applies on top of the fixes)

I'll do that, thanks.

-- 
Kalle Valo
