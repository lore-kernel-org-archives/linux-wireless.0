Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:52516 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaISLHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2014 07:07:16 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21532.3709.290408.14356@gargle.gargle.HOWL> (sfid-20140919_130720_787393_FC87DD3A)
Date: Fri, 19 Sep 2014 16:37:41 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH] ath9k: Fix p2p address management
In-Reply-To: <541BE66F.9040307@openwrt.org>
References: <1411111842-24503-1-git-send-email-sujith@msujith.org>
	<541BE66F.9040307@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Wouldn't it make more sense to put this into ath9k_vif_iter()

I wanted to have a single place where we can have
p2p/mcc specific overrides that will not affect the normal
mode. Having a separate function for it seems reasonable, IMO.

Sujith
