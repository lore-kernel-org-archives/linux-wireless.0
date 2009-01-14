Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:59655 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbZANXKW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 18:10:22 -0500
Subject: Re: [PATCH v4 00/11] ath9k: add preliminary support for the AR913x
 SoCs
From: Pavel Roskin <proski@gnu.org>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1231960632-4452-1-git-send-email-juhosg@openwrt.org>
References: <1231960632-4452-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 18:10:18 -0500
Message-Id: <1231974618.4269.90.camel@dv> (sfid-20090115_001027_055983_4ACFAACB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-01-14 at 20:17 +0100, Gabor Juhos wrote:
> This patch set introduces preliminary support for the Atheros' AR9130/AR9132
> SoCs built-in WMAC device. Tested with compat-wireless-2.6 and 2.6.27.10 
> kernel on the following device:
>   * Atheros AP83-050 reference board (AR9132 SoC, AR9106 RF)
>   * TRENDnet TEW-632BRP router (AR9130 SoC, AR9102 RF)
>   * Mikrotik RB433 board (AR7161 SoC) + AR5416 based miniPCI card

Successfully tested with:

Atheros AR5416 MAC/BB Rev:2 AR5133 RF Rev:81 (miniPCI)
Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81 (CardBus)
Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0 (miniPCIe)

Tested-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
