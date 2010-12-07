Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55120 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab0LGUAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 15:00:07 -0500
Date: Tue, 7 Dec 2010 14:46:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Sujith <m.sujith@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k_htc: Fix suspend/resume
Message-ID: <20101207194646.GG2700@tuxdriver.com>
References: <19701.62091.644444.121284@gargle.gargle.HOWL>
 <20101202193024.GC2358@tuxdriver.com>
 <19704.23185.565826.890275@gargle.gargle.HOWL>
 <AANLkTinPLPoAHxauaXj8Sj=zjyHQPyxO0ku342ersZQ4@mail.gmail.com>
 <19709.45926.38551.25130@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19709.45926.38551.25130@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 07, 2010 at 09:39:10AM +0530, Sujith wrote:
> Luis R. Rodriguez wrote:
> > Just curious, if you revert this patch and apply the ones I just
> > posted, does it fix it, or is this patch required either way?
> 
> Well, I don't see this patch in -testing, -next-2.6 or -2.6.
> Maybe Linville overlooked this patch.

Obviously I didn't overlook it, or I wouldn't have asked about whether
or not it should go to 2.6.37...

> Applying 4/5 and 5/5 from your series seems to fix the issue though.
> I am able to suspend/resume without hiccups with UB95.

But now this begs the question of whether this should be applied at all?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
