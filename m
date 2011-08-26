Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33303 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab1HZOpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 10:45:12 -0400
Date: Fri, 26 Aug 2011 10:30:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 1 more question about sending patches with dependencies
Message-ID: <20110826143015.GG2579@tuxdriver.com> (sfid-20110826_164517_125801_2D353F8F)
References: <CACna6rwzzV=YSkATvLwKk4fcEgtiOjQ9+VihSet_og+y4KkqpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rwzzV=YSkATvLwKk4fcEgtiOjQ9+VihSet_og+y4KkqpA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 26, 2011 at 11:43:48AM +0200, Rafał Miłecki wrote:
> I want to send patch that depends on
> [RFC/RFT] b43: Relax requirement for descriptors to be in the DMA zone
> 
> I guess this is already in the John's queue, as Michael asked to apply
> it even despite the fact it's RFC/RFT.
> 
> Do I have to wait until pushing that patch into wireless-next /
> wireless-testing? Or can I just submit my patch? Or should I re-submit
> the mentioned patch as part of my patchset?

Yes, please repost it (with [PATCH] and Michael's S-o-b) as part of
your series.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
