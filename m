Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43273 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723AbZLNQVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 11:21:50 -0500
Received: by ewy19 with SMTP id 19so3553647ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 08:21:48 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: Revised wireless tree management practices
Date: Mon, 14 Dec 2009 17:18:21 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20091209211054.GB32058@tuxdriver.com> <20091214142602.GC18945@tuxdriver.com> <20091214.071917.82036377.davem@davemloft.net>
In-Reply-To: <20091214.071917.82036377.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <200912141718.21296.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 December 2009 04:19:17 pm David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Mon, 14 Dec 2009 09:26:02 -0500
> 
> > On Mon, Dec 14, 2009 at 03:16:12PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > 
> >> Now if only somebody could come up with a way to split 'monstermerges'
> >> for Linus tree into something more fine-grained (thousands of commits in
> >> a single merge is too much for anyone not directly involved into current
> >> networking developments IMHO) I would be completely satisfied. ;)
> > 
> > You'll have to talk to Dave about that one, although FWIW I'm not
> > sure how to prevent that with the current "merge window" policy...
> 
> Well, the merge window event does not exist in a vacuum.
> 
> Development is happening all during this time and checking the
> subsystem trees of interest to you every week or so will do wonders to
> your sanity. :-)

The problem is that repeating this for every subsystem tree out there does
indeed wonders to ones (in)sanity. :)

--
Bartlomiej Zolnierkiewicz
