Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:51669 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982Ab3BHOIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:08:06 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20757.1658.671850.460794@gargle.gargle.HOWL> (sfid-20130208_150810_244314_F2113231)
Date: Fri, 8 Feb 2013 19:36:50 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
In-Reply-To: <511505E1.9080009@openwrt.org>
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org>
	<20756.65038.7020.514691@gargle.gargle.HOWL>
	<511505E1.9080009@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> I'm pretty sure it's because the algorithm isn't designed to handle more
> rates. It's a step-up/step-down type algorithm, and those typically only
> work with a sorted rateset, preferably duplicate free.
> 
> Minstrel_ht selects rates in a different way that doesn't have the same
> limitations, so it can use the full rateset.

Makes sense.

Sujith
