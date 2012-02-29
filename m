Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60276 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675Ab2B2SRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 13:17:03 -0500
Date: Wed, 29 Feb 2012 13:08:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com
Subject: Re: [PATCH 3.3 1/4] Revert "ath9k_hw: Fix false tx hung detection in
 AR9003 chips"
Message-ID: <20120229180825.GB13733@tuxdriver.com> (sfid-20120229_191707_052781_31AD59DD)
References: <1330369122-60220-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1330369122-60220-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 07:58:39PM +0100, Felix Fietkau wrote:
> The approach of this change is flawed, as it triggers tx status processing
> from more callsites, yet the chips only have one global tx status queue.
> Subsequent patches will properly fix the issue that this one tried to address.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

How flawed is the current approach?  That commit looks like it has been
around for months already.  Does it really _need_ to be fixed in 3.3?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
