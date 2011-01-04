Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47799 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1ADTpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 14:45:07 -0500
Date: Tue, 4 Jan 2011 14:43:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: Re: [PATCH v2 1/6] ath9k_htc: Fix warning on device removal
Message-ID: <20110104194337.GB13239@tuxdriver.com>
References: <19737.42640.829281.50449@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19737.42640.829281.50449@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 28, 2010 at 02:27:52PM +0530, Sujith wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> The commit "ath9k_hw: warn if we cannot change the power to the chip"
> introduced a new warning to indicate chip powerup failures, but this
> is not required for devices that have been removed. Handle USB device
> removal properly by checking for unplugged status.
> 
> For PCI devices, this warning will still be seen when the card is pulled
> out, not sure how to check for card removal.
> 
> Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>

This doesn't seem to apply cleanly?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
