Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50156 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbYLQQaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 11:30:14 -0500
Date: Wed, 17 Dec 2008 11:18:05 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org, Artur Skawina <art.08.09@gmail.com>
Subject: Re: [PATCH] p54usb: bring first generation devices back to life
Message-ID: <20081217161805.GC12679@tuxdriver.com> (sfid-20081217_173019_558875_1728A527)
References: <200812171204.43946.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200812171204.43946.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 17, 2008 at 12:04:43PM +0100, Christian Lamparter wrote:
> This patch fixes a serious regression (introduced by:
> "p54: fix memory management" 872037115977dc0 )
> that affected isl3886+net2280 usb devices operation.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> Artur, can you please test the attached patch.
> if it works, please add a tested-by/acked/signed-off (whatever you want) line.
> ---
> John,
> 
> This patch is made against the current wireless-testing.
> (so I hope you don't get any rejects if you merge put it into wireless-2.6 straight away).
> Of course, I tried to apply them on top of the last patch (free after tx) and all you
> get is little complaint about offsets.. e.g:

AFAICT, the "p54: fix memory management" is not in wireless-2.6.
Perhaps you meant wireless-next-2.6?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
