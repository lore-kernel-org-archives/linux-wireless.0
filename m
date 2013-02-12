Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:53652 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759860Ab3BLOkY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 09:40:24 -0500
Message-ID: <1360680021.5128.37.camel@joe-AO722> (sfid-20130212_154027_274520_4253473C)
Subject: Re: [PATCH 01/14] cw1200: v4: low-level hardware I/O functions
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Solomon Peachy <pizza@shaftnet.org>, linux-wireless@vger.kernel.org
Date: Tue, 12 Feb 2013 06:40:21 -0800
In-Reply-To: <87vc9xac42.fsf@purkki.adurom.net>
References: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
	 <1360355527-12159-2-git-send-email-pizza@shaftnet.org>
	 <1360372559.13487.14.camel@joe-AO722> <20130211185322.GB3123@shaftnet.org>
	 <1360609295.2028.44.camel@joe-AO722> <87vc9xac42.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 15:35 +0200, Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
> 
> >> Question -- as a matter of policy, is the goal to have a completely 
> >> clean checkpatch run?  I get that there should be no ERRORs, but 
> >> WARNINGs/CHECKs are not considered fatal for a reason, right?
> >
> > No.  It's just a guideline.  As far as I'm concerned,
> > ignore every checkpatch message you don't agree with.
> 
> BTW, I think this is becoming a major problem. I have had discussions
> with various people who consider checkpatch as some sort of automatic
> upstream compliance system. I'm a bit worried about that. People should
> consider just as a tool next to other tools, not as the holy bible.

Hi Kalle.

As you probably know, I am not an upstream maintainer.

For drivers/net and drivers/staging, the two primary
upstream maintainers do seem to prefer that most all
checkpatch messages be addressed before acceptance.

Those two paths are ~20% of all patches.

Most other maintainers don't seem to care so much.

> Joe, when working with checkpatch documentation you could try to
> emphasise that part (or it might be that you have already done that).

Patches welcome.

cheers, Joe

