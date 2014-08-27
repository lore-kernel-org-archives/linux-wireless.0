Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:47421 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaH0Kqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 06:46:51 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21501.46881.118286.21558@gargle.gargle.HOWL> (sfid-20140827_124654_596604_06DBDD49)
Date: Wed, 27 Aug 2014 16:16:57 +0530
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 1/4] ath9k: Fix channel context transition
In-Reply-To: <20140827104007.GA4242@jouni.qca.qualcomm.com>
References: <1409121445-11484-1-git-send-email-sujith@msujith.org>
	<1409121445-11484-2-git-send-email-sujith@msujith.org>
	<53FD990F.8050606@openwrt.org>
	<21501.43772.648788.951689@gargle.gargle.HOWL>
	<20140827104007.GA4242@jouni.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> You can send as many nullfunc Data frames as you want and pretty much
> whenever you want.. If the AP has information indicating that the STA is
> in power save mode, this frame needs to be sent. If the AP doesn't have
> such information or the STA does not know what the state is, this frame
> can still be sent. I would skip this only if the STA is reasonably
> certain the AP does not have it recorded to be in power save mode.
> 
> In addition to power save management, nullfunc frames can be used for
> number of other purposes, e.g., to check that the association is valid
> and to trigger operations (well, that is related to power save). In any
> case, there are no rules (other than normal Data frame rules) that
> somehow limit the STA from sending this frame.

Thanks for clarifying. This patch is unnecessary then.

John, please drop this patch.

Sujith
