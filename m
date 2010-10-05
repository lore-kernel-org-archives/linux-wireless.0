Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:54597 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab0JEEjC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 00:39:02 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 21:38:54 -0700
Date: Tue, 5 Oct 2010 10:08:57 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 3/4] ath9k_hw: clean up register write buffering
Message-ID: <20101005043856.GB2462@senthil-lnx.users.atheros.com>
References: <1286125639-15137-1-git-send-email-nbd@openwrt.org>
 <1286125639-15137-2-git-send-email-nbd@openwrt.org>
 <1286125639-15137-3-git-send-email-nbd@openwrt.org>
 <20101004085608.GA5931@vmraj-lnx.users.atheros.com>
 <4CA9C03D.9010503@openwrt.org>
 <4CAA0D5E.1080200@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CAA0D5E.1080200@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 04, 2010 at 10:52:38PM +0530, Felix Fietkau wrote:
> Merge those two ops and also ensure that the flush is only issued after
> all codepaths are done buffering.
I guess this comment is not applicable anymore with this patch and can be
removed.
