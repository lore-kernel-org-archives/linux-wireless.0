Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:37306 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbZANTRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 14:17:12 -0500
Message-ID: <496E39C2.8040208@openwrt.org> (sfid-20090114_201728_263236_1EACCA04)
Date: Wed, 14 Jan 2009 20:15:14 +0100
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
Subject: Re: [PATCH v3 00/11] ath9k: add preliminary support for the AR913x
 SoCs
References: <1231854029-26810-1-git-send-email-juhosg@openwrt.org> <1231882731.21706.10.camel@dv>
In-Reply-To: <1231882731.21706.10.camel@dv>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin =EDrta:
> On Tue, 2009-01-13 at 14:40 +0100, Gabor Juhos wrote:
>> This patch set introduces preliminary support for the Atheros' AR913=
0/AR9132
>> SoCs built-in WMAC device. Tested with compat-wireless-2009-01-12 an=
d 2.6.27.10=20
>> kernel on the following devices:
>>   * Atheros AP83-050 reference board (AR9132 SoC, AR9106 RF)
>>   * TRENDnet TEW-632BRP router (AR9130 SoC, AR9102 RF)
>>   * Mikrotik RB433 board (AR7161 SoC) + AR5416 based miniPCI card
>=20
> I confirm that my AR5416 miniPCI is still working with this patch on =
top
> of yesterdays wireless-testing (master-2009-01-12).
>=20
> Unfortunately, patch named "ath9k: move PCI code into separate file"
> doesn't apply to the today's wireless-testing and needs to be rebased=
=2E

Yes. I will post a new set.

>=20
> Current checkpatch.pl gets confused by several patches because an
> "#endif" in the unchanged part somehow causes the preprocessor stack =
to
> underflow:
>=20
> Can't use an undefined value as an ARRAY reference at
> scripts/checkpatch.pl line 453.
>=20
> This appears to be a bug in checkpatch.pl and should not be considere=
d a
> problem in the patches.
>=20

I have noticed it, but i'm not a Perl expert, so I have checked the pat=
ches=20
with checkpatch.pl from 2.6.28.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
