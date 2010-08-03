Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39719 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab0HCPJY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Aug 2010 11:09:24 -0400
Received: from sapphire.tuxdriver.com ([70.61.120.61] helo=linville-8530p.local)
	by smtp.tuxdriver.com with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1OgJ7L-0000rj-CO
	for linux-wireless@vger.kernel.org; Tue, 03 Aug 2010 11:09:23 -0400
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id o73F9pMt006478
	for <linux-wireless@vger.kernel.org>; Tue, 3 Aug 2010 11:09:51 -0400
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id o73F9psF006477
	for linux-wireless@vger.kernel.org; Tue, 3 Aug 2010 11:09:51 -0400
Date: Tue, 3 Aug 2010 10:50:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: wireless merging -- Re: reminder: bug fixes only
Message-ID: <20100803145039.GB4779@tuxdriver.com>
References: <20100802.224837.135539305.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100802.224837.135539305.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 02, 2010 at 10:48:37PM -0700, David Miller wrote:
> 
> 2.6.35 is out, we're about to enter the merge window, so
> if it isn't already in my tree I don't want to see it unless
> it's a bug fix.

In case you missed it, Dave has made the "no more new stuff" call.
Anything that wasn't included in the pull request I sent on Thursday
will not be included in 2.6.36.  The exception, of course, is bug
(particularly regression) fixes.  If something you have already posted
fits that category, feel free to send me a hint to that effect.
Anything new intended for 2.6.36 should indicate that in the patch
posting.

Generally Stephen requests that nothing be available in the -next
trees during the merge window that isn't being sent to Linus.
The wireless-next-2.6 tree feeds wireless-testing, so you should not
expect to see any post-2.6.36 patches in either of those trees until
the merge window closes in slightly less than two weeks from now.
Fixes will be available as normal.

Thanks for your patience!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
