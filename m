Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51840 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZCXUAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 16:00:42 -0400
Date: Tue, 24 Mar 2009 15:48:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/8] mac80211 aggregation improvements
Message-ID: <20090324194847.GC19335@tuxdriver.com> (sfid-20090324_210045_240765_12925B51)
References: <20090323162834.154525349@sipsolutions.net> <1237883293.6278.9.camel@johannes.local> <43e72e890903240913iee51dcbnfa2409e01d4dd5c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890903240913iee51dcbnfa2409e01d4dd5c0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 09:13:21AM -0700, Luis R. Rodriguez wrote:
> On Tue, Mar 24, 2009 at 1:28 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2009-03-23 at 17:28 +0100, Johannes Berg wrote:
> >
> >> Here's my patch set for improving aggregation
> >
> > John, can I convince you to put this on track for .30 despite being
> > posted just hours before the merge window officially opened? The reason
> > I'm asking is that otherwise I'll have to support two code bases with
> > rather different ways to have aggregation working for iwlwifi again,
> > with different sets of bugs and different ways to fix it. This patch set
> > has also been tested fairly extensively already [1] inside Intel for
> > iwlwifi hardware and by Sujith for ath9k (and myself for both).
> 
> It is not accurate to say Sujith has extensively tested this for
> ath9k, he probably just ran it a few times. So I cannot say we are as
> comfortable with the patches as you or Intel seem to be already.

Johannes,

Given Luis's objection I'm inclined to delay.  I have asked
him to try to "get comfortable" with this patch series over the next
few days.  If that happens, then I'll try to get this merged during
the window.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
