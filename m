Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:55476 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaB1Swh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 13:52:37 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21264.56017.114049.511221@gargle.gargle.HOWL> (sfid-20140228_195241_145849_D665CC5C)
Date: Sat, 1 Mar 2014 00:22:01 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/2] ath9k_hw: tweak noise immunity thresholds for older chipsets
In-Reply-To: <1393610545-68025-2-git-send-email-nbd@openwrt.org>
References: <1393610545-68025-1-git-send-email-nbd@openwrt.org>
	<1393610545-68025-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Older chipsets are more sensitive to high PHY error counts, and the
> current noise immunity thresholds were based on tests run at QCA with
> newer chipsets.
> 
> This patch brings back the values from the old ANI implementation for
> old chipsets, and it also disables weak signal detection on an earlier
> noise immunity level, to improve overall radio stability on affected
> devices.

Which devices ?

Since the old values were used in the old ANI implementation, I am not sure
how just retrofitting them into the new ANI algorithm can improve things...

Sujith
