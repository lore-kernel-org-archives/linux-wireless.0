Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:54565 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0KEAPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 20:15:04 -0400
Date: Fri, 5 Nov 2010 01:15:01 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 1/7] mwl8k: add firmware files for 8366
Message-ID: <20101105001501.GE30287@mail.wantstofly.org>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com> <20101102082254.GL1733@mail.wantstofly.org> <AANLkTi=iQgc+cMTrwGWyriHvOCGhAZ7TU+41ytBRYtea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=iQgc+cMTrwGWyriHvOCGhAZ7TU+41ytBRYtea@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 03, 2010 at 05:19:11PM -0700, Brian Cavagnolo wrote:

> >> From: Nishant Sarmukadam <nishants@marvell.com>
> >>
> >> Add Helper image, client image (4.1.0.3) and ap image (5.2.6.6)
> >>
> >> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> >> Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
> >
> > NAK, for obvious reasons.
> >
> > Also, spamming thousands of people's inboxes with 500kb firmware
> > patches is generally not a nice thing to do.
> 
> Well, patches containing hundreds of kB of binary firmware do pass
> through this mailing list.

Not through linux-wireless@.


> However, a closer inspection reveals that these were destined for the
> linux-firmware with linux-wireless CC'd.

Since they are patching different things, they shouldn't even be in
the same patch series anyway.
