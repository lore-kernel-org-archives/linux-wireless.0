Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33438 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab3HMKSC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 06:18:02 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21002.1787.16861.319684@gargle.gargle.HOWL> (sfid-20130813_121806_739507_5A6FD60A)
Date: Tue, 13 Aug 2013 15:44:19 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 01/15] ath9k: Add MAX_AMSDU to supported HT capabilities
In-Reply-To: <5209FFED.1040901@openwrt.org>
References: <1376300502-2741-1-git-send-email-sujith@msujith.org>
	<1376300502-2741-2-git-send-email-sujith@msujith.org>
	<5209FFED.1040901@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> I think processing of fragmented rx in ath9k needs to change before we
> can enable this. At the moment the driver only supports assembling a
> frame from two fragments, which isn't enough to receive large A-MSDU
> packets.

You are right, I'll drop this patch.

Sujith
