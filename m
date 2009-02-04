Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:58851 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbZBDPu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 10:50:57 -0500
Received: by ewy14 with SMTP id 14so3462684ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 07:50:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090204151854.GC3845@tuxdriver.com>
References: <a4c529250902040227g35a375fdu35c2360f0916dba6@mail.gmail.com>
	 <a4c529250902040243r6146f56vb2c656818385c749@mail.gmail.com>
	 <3ace41890902040717l7174fc0xc4589f17ea283e9c@mail.gmail.com>
	 <20090204151854.GC3845@tuxdriver.com>
Date: Wed, 4 Feb 2009 15:50:55 +0000
Message-ID: <3ace41890902040750v61e42579h945e6f9fb70d575d@mail.gmail.com> (sfid-20090204_165101_964017_3165A890)
Subject: Re: zd1211rw NEW RF Type
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ismael Ojeda Perez <iojedaperez@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 4, 2009 at 3:18 PM, John W. Linville <linville@tuxdriver.com> wrote:

>> You probably don't hang out in the right place... two people on the
>> sourceforge zd1211 mailing list recently reported that
>> MAXIM_NEW_RF=0x08 is just the same as    UW2453_RF=0x09 ; and one of

> Or someone can send a patch with a report that it is working for them
> and I'll just merge it... :-)

The patch and success report was posted to the sourceforge zd1211
mailing list 2 weeks ago - it is actually in the mailing list archive
( http://sourceforge.net/mailarchive/forum.php?forum_name=zd1211-devs
, 2nd item from top) I think Daniel Drake and a few of the zd1211rw
people are on that list . For slightly controversial(?) change like
this - comparing to just adding vendor+product ids - it is probably
more appropriate if/when one of them decide to put it in...

It is likely that 0x08 is just an older 0x09, so it is probably more
appropriate to put the 0x08 RF id before, rather than after the 0x09
case as in the posted patch to the zd1211 mailing list.

(I have little to do with zd1211rw, just happened to own a zd1211b
device which I run with the vendor (non-rw) driver as my AP, so I
"listen-in" to zd1211-devs ...)
