Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47160 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbZLNULd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 15:11:33 -0500
Received: by ewy19 with SMTP id 19so3793895ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 12:11:32 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: Revised wireless tree management practices
Date: Mon, 14 Dec 2009 21:09:38 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <200912142016.00169.bzolnier@gmail.com> <200912142042.13251.bzolnier@gmail.com> <20091214.114652.243547684.davem@davemloft.net>
In-Reply-To: <20091214.114652.243547684.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200912142109.38697.bzolnier@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 December 2009 08:46:52 pm David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Mon, 14 Dec 2009 20:42:13 +0100
> 
> > However looking at "Top non-author signoffs in 2.6.31" [1]:
> > 
> > David S. Miller     964 10.1%
> > Ingo Molnar         948 9.9%
> > Greg Kroah-Hartman  582 6.1%
> > ...
> > 
> > it seems that there are people able to do large upstream merges in much
> > more transparent and reviewer-friendly way so it is not like there exists
> > some real physical barrier for not even trying to do things better..
> 
> Greg (USB, staging) and Ingo (scheduler, perf, tracing, x86) each work
> in several disconnected areas, and have you seen the size of the

I would risk saying that in Ingo's case those areas are frequently more
inter-connected than i.e. wireless driver changes and core networking ones...

> staging tree merges? :-)

..and yes, I did take a look at 2.6.33 staging merge before writing my mail.

I think that it was too big personally but it was still only 235 commits:

commit 0e2f7b837600979d5b6f174a6ff695b85942e985
Merge: f58df54 032fec3
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Dec 11 15:25:56 2009 -0800

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6

    * git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6: (235 commits)

1815 networking commits means almost 8x more and while LOC amount for staging
is much higher, networking changes affect 2x more files.

--
Bartlomiej Zolnierkiewicz
