Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:63993 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZLNPBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 10:01:23 -0500
Received: by ey-out-2122.google.com with SMTP id d26so881855eyd.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 07:01:22 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Revised wireless tree management practices
Date: Mon, 14 Dec 2009 15:59:29 +0100
Cc: linux-wireless@vger.kernel.org, davem@davemloft.net
References: <20091209211054.GB32058@tuxdriver.com> <200912141516.12224.bzolnier@gmail.com> <20091214142602.GC18945@tuxdriver.com>
In-Reply-To: <20091214142602.GC18945@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200912141559.29282.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 December 2009 03:26:02 pm John W. Linville wrote:
> On Mon, Dec 14, 2009 at 03:16:12PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> > Now if only somebody could come up with a way to split 'monstermerges'
> > for Linus tree into something more fine-grained (thousands of commits in
> > a single merge is too much for anyone not directly involved into current
> > networking developments IMHO) I would be completely satisfied. ;)
> 
> You'll have to talk to Dave about that one, although FWIW I'm not

Yep, it was directed at him (since he was on cc: already).

> sure how to prevent that with the current "merge window" policy...

Hmmm, there are multiple ideas to investigate even within the current
"merge window" policy.  Decoupling driver trees from core changes should
certainly be possible (it works just fine in the storage area), some
architectures make heavy use of topic branches to prevent 'monstermerge'
issue etc.

Anyway this is just some food for thought for Dave once he finds some
time away from his usual more high-priority activities.. ;)

--
Bartlomiej Zolnierkiewicz
