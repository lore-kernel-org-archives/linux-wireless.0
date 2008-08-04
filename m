Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:45589 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbYHDOYM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 10:24:12 -0400
Date: Mon, 4 Aug 2008 16:23:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net,
	Senthil Balasubramanian <senthilkumar@Atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@lst.de>,
	Jack Howarth <howarth@bromo.msbb.uc.edu>,
	Jouni Malinen <jouni.malinen@Atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	Pavel Roskin <proski@gnu.org>,
	Vasanthakumar Thiagarajan <vasanth@Atheros.com>
Subject: Re: [PATCH 4/4] ath9k: Add new Atheros IEEE 802.11n driver
Message-ID: <20080804142321.GB9892@lst.de> (sfid-20080804_162415_634649_40358F86)
References: <1217834201-14680-1-git-send-email-lrodriguez@atheros.com> <1217834201-14680-2-git-send-email-lrodriguez@atheros.com> <1217834201-14680-3-git-send-email-lrodriguez@atheros.com> <1217834201-14680-4-git-send-email-lrodriguez@atheros.com> <1217834201-14680-5-git-send-email-lrodriguez@atheros.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217834201-14680-5-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 04, 2008 at 12:16:41AM -0700, Luis R. Rodriguez wrote:
> This adds the new mac80211 11n ath9k Atheros driver. Only STA support
> is currently enabled and tested.
> 
> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

No signed off yet, I haven't even read in detail through the whole
driver.  Same is probably true for most other people on this
list.

That beeing said I'm not really in a position to sign off either as
I'm not the mainter nor a major contributor to the patch.
