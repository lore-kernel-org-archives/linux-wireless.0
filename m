Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4498 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934100AbXEGOdZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 10:33:25 -0400
Date: Mon, 7 May 2007 10:11:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>, linux-wireless@vger.kernel.org,
	marcelo@kvack.org, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Please pull 'revert-libertas' branch of wireless-2.6 (was Re: Please pull 'libertas' branch of wireless-2.6)
Message-ID: <20070507141143.GB5125@tuxdriver.com>
References: <20070227205649.GH5826@tuxdriver.com> <45E8CF5E.5090305@garzik.org> <20070303052140.GA31075@infradead.org> <20070507104117.GA31601@infradead.org> <1178539423.3032.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1178539423.3032.24.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 07, 2007 at 08:03:43AM -0400, Dan Williams wrote:
> On Mon, 2007-05-07 at 11:41 +0100, Christoph Hellwig wrote:

> > Of course it's not anywhere near good shape.  Almost all items from my
> > review were completely ignored, and we have another totoally substandard
> > wireless driver with crappy thread handling, a huge number of broken private
> > ioctls and partially absymal codingstyle.

> I've already updated libertas-2.6 git with a ton of updates for this.
> 
> In any case, lets push off any merge until 2.6.23 so the rest of the
> comments can be dealt with:

Alright...Jeff, would you please pull the following branch for upstream ASAP:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git revert-libertas

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
