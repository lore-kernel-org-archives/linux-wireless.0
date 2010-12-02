Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43175 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab0LBTpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 14:45:15 -0500
Date: Thu, 2 Dec 2010 14:30:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k_htc: Fix suspend/resume
Message-ID: <20101202193024.GC2358@tuxdriver.com>
References: <19701.62091.644444.121284@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19701.62091.644444.121284@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 01, 2010 at 12:30:27PM +0530, Sujith wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> The HW has to be set to FULLSLEEP mode during suspend,
> when no interface has been brought up. Not doing this would
> break resume, as the chip won't be powered up at all.
> 
> Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Is this intended for 2.6.37?  It looks like it will apply there.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
