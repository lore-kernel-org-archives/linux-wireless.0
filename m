Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:45744 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaKMADn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 19:03:43 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21603.62903.29605.927800@gargle.gargle.HOWL> (sfid-20141113_010346_491660_6B9D4B15)
Date: Thu, 13 Nov 2014 05:35:11 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 1/6] ath9k: disable overriding AR9340 SLP32 registers
In-Reply-To: <546343EF.5090803@openwrt.org>
References: <1415689644-29693-1-git-send-email-sujith@msujith.org>
	<1415689644-29693-2-git-send-email-sujith@msujith.org>
	<546343EF.5090803@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> What's the point in doing this? The writes don't hurt, and this change
> is making the code uglier.

Well, the code is redundant and I don't see the point in
doing the writes when we don't have to ? We could maybe
restructure it a bit...

Sujith
