Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36090 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2EICy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 22:54:58 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1SRx3J-0002Cu-Dg
	for linux-wireless@vger.kernel.org; Tue, 08 May 2012 22:54:57 -0400
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id q492q9eZ018663
	for <linux-wireless@vger.kernel.org>; Tue, 8 May 2012 22:52:09 -0400
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id q492q9uE018662
	for linux-wireless@vger.kernel.org; Tue, 8 May 2012 22:52:09 -0400
Date: Tue, 8 May 2012 22:52:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: Re: wireless-next rebased from 94c514fe
Message-ID: <20120509025208.GA15753@tuxdriver.com> (sfid-20120509_045502_172223_FC907AD3)
References: <20120509024300.GC2533@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120509024300.GC2533@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 08, 2012 at 10:43:01PM -0400, John W. Linville wrote:

> Regrettably, I found it necessary to rebase the wireless-next tree
> starting from commit 94c514fe.  If you maintain a tree derived from
> wireless-next then you may need to adjust your tree accordingly.
> 
> I apologize for the inconvenience!

I should note that I pulled back from net-next into wireless-next as
part of this process.  This was necessary to resolve some continuing
merge issues related to the NLA_PUT_* removal.  This also means that
net-next bits have made their way into wireless-testing much earlier
than they usually would have done so.

Again, I apologize for the inconvenience and/or confusion that this
might cause.  Please bear through this with me.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
