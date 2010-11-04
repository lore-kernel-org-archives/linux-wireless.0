Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34415 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0KDUo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 16:44:58 -0400
Subject: Re: [PATCH 1/7] mwl8k: add firmware files for 8366
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless@vger.kernel.org,
	Nishant Sarmukadam <nishants@marvell.com>
In-Reply-To: <AANLkTi=iQgc+cMTrwGWyriHvOCGhAZ7TU+41ytBRYtea@mail.gmail.com>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
	 <20101102082254.GL1733@mail.wantstofly.org>
	 <AANLkTi=iQgc+cMTrwGWyriHvOCGhAZ7TU+41ytBRYtea@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 11:36:33 -0400
Message-ID: <1288884993.3517.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-03 at 17:19 -0700, Brian Cavagnolo wrote:

> Well, patches containing hundreds of kB of binary firmware do pass
> through this mailing list.  However, a closer inspection reveals that
> these were destined for the linux-firmware with linux-wireless CC'd.
> My bad.  When I resubmit I'll do it that way.

Before you do that though, you really really need to fix this patch to
not add the firmware to the _kernel_ tree, but to the _firmware_ tree.
Including a proper license for them, of course, and not as ihex crap,
etc.

johannes

