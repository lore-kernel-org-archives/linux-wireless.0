Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:43102 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab1B1OXv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 09:23:51 -0500
Date: Mon, 28 Feb 2011 06:22:43 -0800
From: Greg KH <greg@kroah.com>
To: Vivek Natarajan <vnatarajan@Atheros.com>
Cc: Mohammed Shafi Shajakhan <mshajakhan@Atheros.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [stable 2.6.37][PATCH] ath9k: Fix ath9k to allow CPU
 to enter C3 state.
Message-ID: <20110228142243.GB25724@kroah.com>
References: <1298874054-3803-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1298874054-3803-1-git-send-email-vnatarajan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 28, 2011 at 11:50:53AM +0530, Vivek Natarajan wrote:
> The default qos value of 55 causes higher power consumption
> and the battery drains out quickly. So, remove the pm_qos request
> in the driver and the throughout issue in the Intel Pinetrail
> platforms in which the DMA latency is seen can be fixed with
> the following script:
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/cpudmalatency.c
> http://johannes.sipsolutions.net/files/netlatency.c.txt
> 
> More details can be found in the following bugzilla link:
> https://bugzilla.kernel.org/show_bug.cgi?id=27532
> 
> Cc: stable@kernel.org
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>

Why did you send me 3 copies of this patch, when I don't need any copies
of it?

Totally confused,

greg k-h
