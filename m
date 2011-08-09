Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50388 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1HIUAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 16:00:14 -0400
Date: Tue, 9 Aug 2011 15:51:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH v2 10/13] ath9k_hw: update PMU to improve ripple issue
 for AR9485
Message-ID: <20110809195116.GF10077@tuxdriver.com> (sfid-20110809_220021_360995_5A1AE466)
References: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1311941300-2590-10-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1311941300-2590-10-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 29, 2011 at 05:38:17PM +0530, Rajkumar Manoharan wrote:
> The commit ebefce3d13f8b5a871337ff7c3821ee140c1ea8a failed
> to set proper PMU value to address ripple issue for AR9485.
> 
> Cc: stable@kernel.org
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Please post fixes (particular those that are Cc: stable@kernel.org) 
as separate patch series.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
