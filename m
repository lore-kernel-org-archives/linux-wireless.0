Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:48036 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaIEAsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 20:48:20 -0400
From: Sujith Manoharan <sujith@msujith.org>
Message-ID: <21513.2124.913221.799816@gargle.gargle.HOWL> (sfid-20140905_024824_012761_C82D3E59)
Date: Fri, 5 Sep 2014 06:18:12 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 0/5] ath9k patches
In-Reply-To: <20140904172450.GF3467@tuxdriver.com>
References: <1409730929-30208-1-git-send-email-sujith@msujith.org>
	<20140904172450.GF3467@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> I am having a lot of trouble determining which of your series are
> intended as fixes for the current release (3.17) or updates for the
> next release (3.18).  In this series, several seem like fixes but
> "ath9k: Fix ath_startrecv" seems like a cleanup.
> 
> Would you like to reorganize your patch submissions as fixes
> vs. features?  Or do you want them all to be merged as features
> for 3.18?

All these patches are meant for 3.18. I usually mark immediate
fixes as stable candidates.

I'll be more explicit about this in future.

thanks,
Sujith
