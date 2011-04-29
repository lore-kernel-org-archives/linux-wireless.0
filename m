Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42727 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab1D2Tav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 15:30:51 -0400
Date: Fri, 29 Apr 2011 15:27:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: [PATCH] ath9k: Fix drain txq failure in flush
Message-ID: <20110429192751.GE25999@tuxdriver.com> (sfid-20110429_213055_367418_8153B8D2)
References: <1303984917-12340-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303984917-12340-1-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 28, 2011 at 03:31:57PM +0530, Rajkumar Manoharan wrote:
> While draining the txq in flush, the buffers can be
> added into the tx queue by tx_tasklet which leads to
> unneccesary chip reset.
> 
> This issue was originially found with AR9382 and
> running heavy uplink udp traffic with higher bandwidth
> and doing frequent bgscan.
> 
> Cc: stable@kernel.org
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>

Should this be a fix for 2.6.39?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
