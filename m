Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33028 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZBDQPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 11:15:51 -0500
Date: Wed, 4 Feb 2009 11:15:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Ismael Ojeda Perez <iojedaperez@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: zd1211rw NEW RF Type
Message-ID: <20090204161502.GD3845@tuxdriver.com> (sfid-20090204_171555_263638_2D10BEFB)
References: <a4c529250902040227g35a375fdu35c2360f0916dba6@mail.gmail.com> <a4c529250902040243r6146f56vb2c656818385c749@mail.gmail.com> <3ace41890902040717l7174fc0xc4589f17ea283e9c@mail.gmail.com> <20090204151854.GC3845@tuxdriver.com> <3ace41890902040750v61e42579h945e6f9fb70d575d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3ace41890902040750v61e42579h945e6f9fb70d575d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 04, 2009 at 03:50:55PM +0000, Hin-Tak Leung wrote:
> On Wed, Feb 4, 2009 at 3:18 PM, John W. Linville <linville@tuxdriver.com> wrote:
> 
> >> You probably don't hang out in the right place... two people on the
> >> sourceforge zd1211 mailing list recently reported that
> >> MAXIM_NEW_RF=0x08 is just the same as    UW2453_RF=0x09 ; and one of
> 
> > Or someone can send a patch with a report that it is working for them
> > and I'll just merge it... :-)
> 
> The patch and success report was posted to the sourceforge zd1211
> mailing list 2 weeks ago - it is actually in the mailing list archive
> ( http://sourceforge.net/mailarchive/forum.php?forum_name=zd1211-devs
> , 2nd item from top) I think Daniel Drake and a few of the zd1211rw
> people are on that list . For slightly controversial(?) change like
> this - comparing to just adding vendor+product ids - it is probably
> more appropriate if/when one of them decide to put it in...

This doesn't seem any more contorversial than a USB ID to me...?

> It is likely that 0x08 is just an older 0x09, so it is probably more
> appropriate to put the 0x08 RF id before, rather than after the 0x09
> case as in the posted patch to the zd1211 mailing list.

ACK on the style note.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
