Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34253 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab3K0Qjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 11:39:35 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21142.7985.56874.811684@gargle.gargle.HOWL> (sfid-20131127_173938_638508_E82E9A29)
Date: Wed, 27 Nov 2013 22:04:57 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: Antonio Quartulli <antonio@meshcoding.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k pending patches
In-Reply-To: <52961714.20909@openwrt.org>
References: <1385547828-4330-1-git-send-email-sujith@msujith.org>
	<21141.51790.303263.385517@gargle.gargle.HOWL>
	<5295EB1D.1050604@meshcoding.com>
	<21142.4319.977971.553792@gargle.gargle.HOWL>
	<52961714.20909@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> There's no need to patch the initvals for this issue at all. ath9k has
> enabled AR_PCU_ALWAYS_PERFORM_KEYSEARCH via ah->misc_mode for a long
> time now.

Yes, you are right. So the timer workaround is needed, I guess.

Sujith
