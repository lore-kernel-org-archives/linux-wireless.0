Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45928 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3LXN3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Dec 2013 08:29:10 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21177.35573.334187.908805@gargle.gargle.HOWL> (sfid-20131224_142930_977673_A000A2B1)
Date: Tue, 24 Dec 2013 18:54:05 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/11] ath9k: Fix "cc_lock" usage
In-Reply-To: <52B9715F.8000002@openwrt.org>
References: <1387862067-25457-1-git-send-email-sujith@msujith.org>
	<1387862067-25457-11-git-send-email-sujith@msujith.org>
	<52B9715F.8000002@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> I think you forgot to remove the now unused 'flags' variable in a few
> places.

Which ones ? -Wunused-variable is enabled and gcc doesn't show any warnings...

Sujith
