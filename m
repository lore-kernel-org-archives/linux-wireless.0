Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34992 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab3HFI5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 04:57:19 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20992.44003.432490.369935@gargle.gargle.HOWL> (sfid-20130806_105723_514174_D3B5E74E)
Date: Tue, 6 Aug 2013 13:25:15 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 09/12] ath9k: always clear ps filter bit on new assoc
In-Reply-To: <1375732583-39001-9-git-send-email-nbd@openwrt.org>
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
	<1375732583-39001-9-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Otherwise in some cases, EAPOL frames might be filtered during the
> initial handshake, causing delays and assoc failures.

I think this is a stable candidate.

Sujith
