Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47982 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933007Ab2GYNsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 09:48:51 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1Su1xI-0005O0-S4
	for linux-wireless@vger.kernel.org; Wed, 25 Jul 2012 09:48:48 -0400
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.5/8.14.4) with ESMTP id q6PDXghC005273
	for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 09:33:43 -0400
Received: (from linville@localhost)
	by linville-8530p.local (8.14.5/8.14.5/Submit) id q6PDXgnR005272
	for linux-wireless@vger.kernel.org; Wed, 25 Jul 2012 09:33:42 -0400
Date: Wed, 25 Jul 2012 09:33:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: wireless-next closed until -rc1
Message-ID: <20120725133342.GB3272@tuxdriver.com> (sfid-20120725_154904_507182_5C9BB31B)
References: <20120724.140209.436222867574556913.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120724.140209.436222867574556913.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 24, 2012 at 02:02:09PM -0700, David Miller wrote:
> 
> Linus has pulled all of the pending merge window work from net-next
> into his tree.
> 
> Therefore, net-next is closed until after the end of the merge
> window.
> 
> 'net' is open for bug fixes

The wireless trees feed Dave's net trees, so we follow his rules.
Besides, they are really Linus' rules in the first place.

So, please be aware that no non-fix wireless patches will be merged
until after -rc1 is released in another ~1.5 weeks.  This means you!
Fixes are welcome, of course.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
