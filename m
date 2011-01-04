Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:27900 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab1ADTv4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 14:51:56 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 Jan 2011 11:51:39 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19747.31310.362485.182344@gargle.gargle.HOWL>
Date: Wed, 5 Jan 2011 01:21:42 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: Sujith <m.sujith@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] ath9k_htc: Fix warning on device removal
In-Reply-To: <20110104194337.GB13239@tuxdriver.com>
References: <19737.42640.829281.50449@gargle.gargle.HOWL>
	<20110104194337.GB13239@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Tue, Dec 28, 2010 at 02:27:52PM +0530, Sujith wrote:
> > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> > 
> > The commit "ath9k_hw: warn if we cannot change the power to the chip"
> > introduced a new warning to indicate chip powerup failures, but this
> > is not required for devices that have been removed. Handle USB device
> > removal properly by checking for unplugged status.
> > 
> > For PCI devices, this warning will still be seen when the card is pulled
> > out, not sure how to check for card removal.
> > 
> > Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> This doesn't seem to apply cleanly?

Sent a rebased version. Thanks.

Sujith
