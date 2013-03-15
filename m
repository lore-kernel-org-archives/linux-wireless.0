Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36456
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212Ab3COSe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 14:34:58 -0400
Date: Fri, 15 Mar 2013 14:34:57 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.9] ath9k: limit tx path hang check to normal data queues
Message-ID: <20130315183457.GB2676@bombadil.infradead.org> (sfid-20130315_193519_221946_ECC68EE8)
References: <1363360724-44435-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363360724-44435-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 15, 2013 at 04:18:44PM +0100, Felix Fietkau wrote:
> The beacon and multicast-buffer queues are managed by the beacon
> tasklet, and the generic tx path hang check does not help in any way
> here. Running it on those queues anyway can introduce some race
> conditions leading to unnecessary chip resets.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

This applies to v3.8 as well, do you want it there as well?

  Luis
