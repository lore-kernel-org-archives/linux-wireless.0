Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56525 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3FDLtv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 07:49:51 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20909.54201.497575.556986@gargle.gargle.HOWL> (sfid-20130604_134954_971519_398F2A2C)
Date: Tue, 4 Jun 2013 17:17:05 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/6] ath9k: Fix ANI monitoring
In-Reply-To: <51ADD058.5000003@openwrt.org>
References: <1370340695-29003-1-git-send-email-sujith@msujith.org>
	<1370340695-29003-2-git-send-email-sujith@msujith.org>
	<51ADD058.5000003@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> With this patch, the raise-limit is always 3500, you should change it to
> 1000 when removing the above-/below-INI distinction.

Thanks, I'll fix this and send a v2.

Sujith
