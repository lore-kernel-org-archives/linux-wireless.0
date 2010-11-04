Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65079 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0KDUxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 16:53:47 -0400
Received: by wyb36 with SMTP id 36so352876wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 13:53:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1288884993.3517.1.camel@jlt3.sipsolutions.net>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
 <20101102082254.GL1733@mail.wantstofly.org> <AANLkTi=iQgc+cMTrwGWyriHvOCGhAZ7TU+41ytBRYtea@mail.gmail.com>
 <1288884993.3517.1.camel@jlt3.sipsolutions.net>
From: Brian Cavagnolo <brian@cozybit.com>
Date: Thu, 4 Nov 2010 13:53:25 -0700
Message-ID: <AANLkTik9GDfbqggpf+o2LSog8VwrH4FtdhvWeoKLNzjw@mail.gmail.com>
Subject: Re: [PATCH 1/7] mwl8k: add firmware files for 8366
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless@vger.kernel.org,
	Nishant Sarmukadam <nishants@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 4, 2010 at 8:36 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2010-11-03 at 17:19 -0700, Brian Cavagnolo wrote:
>
>> Well, patches containing hundreds of kB of binary firmware do pass
>> through this mailing list.  However, a closer inspection reveals that
>> these were destined for the linux-firmware with linux-wireless CC'd.
>> My bad.  When I resubmit I'll do it that way.
>
> Before you do that though, you really really need to fix this patch to
> not add the firmware to the _kernel_ tree, but to the _firmware_ tree.
> Including a proper license for them, of course, and not as ihex crap,
> etc.

Understood.  This is underway.

Ciao,
Brian
