Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:50685 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315AbZAOIHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 03:07:35 -0500
Message-ID: <496EEE8B.3030702@openwrt.org> (sfid-20090115_090742_583592_68763440)
Date: Thu, 15 Jan 2009 09:06:35 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Christoph Hellwig <hch@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath9k-devel] [PATCH v4 02/11] ath9k: convert to use bus-agnostic
 DMA routines
References: <1231960632-4452-1-git-send-email-juhosg@openwrt.org>	<1231960632-4452-3-git-send-email-juhosg@openwrt.org> <18798.42051.400380.269490@localhost.localdomain>
In-Reply-To: <18798.42051.400380.269490@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith =EDrta:
> Gabor Juhos wrote:
>> Convert to use bus-agnostic DMA routines to make it usable on AHB bu=
s as well.
>>
>=20
> This pretty much makes the previous patch redundant.

Yes. Although i can merge the two patches, but in my opinion it is easi=
er to
review them in this way.

-Gabor

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
