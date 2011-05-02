Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55643 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759191Ab1EBOpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 10:45:54 -0400
Date: Mon, 2 May 2011 10:37:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wl12xx: support FW TX inactivity triggers
Message-ID: <20110502143757.GD2544@tuxdriver.com> (sfid-20110502_164557_671112_74299CF1)
References: <1303849311-8817-1-git-send-email-arik@wizery.com>
 <BANLkTi=mJE+M79-XOJsTPRu1zGodiiZ8bg@mail.gmail.com>
 <BANLkTinnQgZGjZOigQuUSVD0kCBTuzUE1A@mail.gmail.com>
 <1304329855.12586.234.camel@cumari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1304329855.12586.234.camel@cumari>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 02, 2011 at 12:50:55PM +0300, Luciano Coelho wrote:
> Hi John and Arik,
> 
> On Sat, 2011-04-30 at 00:09 +0300, Arik Nemtsov wrote:
> > Hey John,
> > 
> > Looking at the latest git, it seems you've picked up this patch
> > (commit 47684808fd89d6809c0886e06f8ac324252499d8).
> > This is unfortunate, since there's currently a FW bug that will cause
> > many disconnections in STA mode with this patch.
> > 
> > How would we go about reverting this?
> 
> I have reverted this patch in the wl12xx.git tree.  This required a bit
> of merging and we needed the revert in order to proceed with our tests.
> 
> So, John, please don't revert this in your tree.  My revert will come in
> my next pull-request which will come in a couple of days, after our
> internal test round is done.
> 
> Thanks!

OK, sounds good.  FWIW, this is what I meant when I said "Do the
wl12xx guys still want this?"  Granted, that was about the other
patch in the series, but I kinda presumed that they were related...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
