Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52739 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab1LOVp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 16:45:28 -0500
Date: Thu, 15 Dec 2011 16:38:22 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-12-15
Message-ID: <20111215213822.GB2561@tuxdriver.com> (sfid-20111215_224554_619909_EFEE4D97)
References: <20111215191523.GA2561@tuxdriver.com>
 <CACna6rw736JdkoM8zKxorCFd5oy08QTwWZ6PutoJPSr3ZN8hTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rw736JdkoM8zKxorCFd5oy08QTwWZ6PutoJPSr3ZN8hTg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2011 at 09:04:29PM +0100, Rafał Miłecki wrote:
> 2011/12/15 John W. Linville <linville@tuxdriver.com>:
> > commit 42a3b63bb2ca4996a3d1210a004eae2333f1119e
> >
> > Dave,
> >
> > Here are a few more fixes intended for the 3.2 release.  They are
> > all small and narrowly focused.
> 
> John, I've made a mistake and didn't use [PATCH 3.2] header to make it
> clean my patch is fix. Could you take a look at
> [PATCH] bcma: support for suspend and resume
> please?
> 
> It's not one-liner, but fixes lock ups, which I believe - we really
> want to avoid.

It's late in the release cycle, and Dave specifically asked me to slow down.

Are these suspend/resume lockups a regression?  Or have they always
been there?  Do they happen to everyone?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
