Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:47695 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab2LMSm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 13:42:26 -0500
Cc: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Date: Thu, 13 Dec 2012 10:45:54 -0800
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 2/2] ath9k_hw: use the devres API for allocations
Message-ID: <20121213184554.GO15974@pogo> (sfid-20121213_194228_364322_A563FBDF)
References: <1355314463-17742-1-git-send-email-nbd@openwrt.org>
 <1355314463-17742-2-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1355314463-17742-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 12, 2012 at 01:14:23PM +0100, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

>  7 files changed, 37 insertions(+), 80 deletions(-)

Oh hell yeah.

  Luis
