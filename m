Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38058 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3FQBYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jun 2013 21:24:55 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20926.25783.21390.524622@gargle.gargle.HOWL> (sfid-20130617_032519_792355_67C2CB1B)
Date: Mon, 17 Jun 2013 06:51:59 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, jkp@iki.fi, gfmichaud@gmail.com
Subject: Re: [PATCH v2] ath9k: Add custom parameters for CUS198
In-Reply-To: <51BDFED6.1060509@openwrt.org>
References: <1371144086-10150-1-git-send-email-sujith@msujith.org>
	<51BDFED6.1060509@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Shouldn't the ath9k_hw_cfg_output line change as well, otherwise you
> simply add an unused-but-set variable here.

Hm, I thought I sent the updated patch in v2.
Thanks for catching this !

Sujith
