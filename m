Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:37497 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab0I1KMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 06:12:05 -0400
Subject: Re: [ANN] New git tree for wl1271 integration
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: John Linville <linville@tuxdriver.com>
In-Reply-To: <1285573698.5768.67.camel@chilepepper>
References: <1285573698.5768.67.camel@chilepepper>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 13:11:45 +0300
Message-ID: <1285668705.28270.67.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 09:48 +0200, Coelho Luciano (Nokia-MS/Helsinki)
wrote:
> Hi all,
> 
> We are changing the integration model for wl1271 patches.  As agreed
> with John, I have created a new git tree [1] for the wl1271 driver from
> which John will pull.
> 
> The reason for doing this, is that we are going to review every patch
> and test them before integrating into wireless-next.
> 
> So, from now on, please send all the patches for wl1271 to me (as well
> as to the linux-wireless mailing list, obviously) and we will review and
> integrate them into wl12xx/master.  After testing that everything still
> works (this part is still work in progress) and we're happy with the
> tree, I will send a pull-request to John for integration into
> wireless-next.  This will happen on a weekly basis.
> 
> Obviously, patches that spread across several drivers or other parts of
> the stack, will be integrated by John directly into wireless-next.  I'll
> be acking the wl1271 part of those patches and John will integrate them.
> 
> If you're developing wl1271 stuff, please base your patches on the
> wl12xx/master git tree, which can be found here:
> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
> 
> If you have any questions, comments, flames or just want to drop me an
> email for any other reason, feel free do to so. :)

I had to reorganize this a bit.  I had based master on wireless-next,
which had missing support for some boards (eg. Zoom).

Now I have rebased master on top of wireless-testing and created a new
branch called wireless-next which is, obviously based on wireless-next.

For development, please use wl12xx/master.  The wl12xx/wireless-next
branch is the "official" branch which will contain the patches that will
be submitted upstream to John's tree.

Sorry for the trouble, but if you have already cloned the wl12xx tree,
you will have to reset your local branches.

-- 
Cheers,
Luca.

