Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:43082 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035AbZAOHMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 02:12:53 -0500
Message-ID: <496EE1A1.10208@openwrt.org> (sfid-20090115_081305_425144_3EC17B58)
Date: Thu, 15 Jan 2009 08:11:29 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v4 00/11] ath9k: add preliminary support for the AR913x
 SoCs
References: <1231960632-4452-1-git-send-email-juhosg@openwrt.org> <1231974618.4269.90.camel@dv>
In-Reply-To: <1231974618.4269.90.camel@dv>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin =EDrta:
> On Wed, 2009-01-14 at 20:17 +0100, Gabor Juhos wrote:
>> This patch set introduces preliminary support for the Atheros' AR913=
0/AR9132
>> SoCs built-in WMAC device. Tested with compat-wireless-2.6 and 2.6.2=
7.10=20
>> kernel on the following device:
>>   * Atheros AP83-050 reference board (AR9132 SoC, AR9106 RF)
>>   * TRENDnet TEW-632BRP router (AR9130 SoC, AR9102 RF)
>>   * Mikrotik RB433 board (AR7161 SoC) + AR5416 based miniPCI card
>=20
> Successfully tested with:
>=20
> Atheros AR5416 MAC/BB Rev:2 AR5133 RF Rev:81 (miniPCI)
> Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81 (CardBus)
> Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0 (miniPCIe)
>=20
> Tested-by: Pavel Roskin <proski@gnu.org>
>=20

Thank you!

-Gabor
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
