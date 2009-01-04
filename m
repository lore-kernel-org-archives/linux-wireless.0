Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:38360 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbZADLRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 06:17:40 -0500
Message-ID: <49609AC0.8090606@openwrt.org> (sfid-20090104_121742_292160_98FD1107)
Date: Sun, 04 Jan 2009 12:17:20 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [RFC 02/12] ath9k: introduce bus specific register access	routines
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org> <1230990262-22923-3-git-send-email-juhosg@openwrt.org> <20090104072706.GB12905@infradead.org>
In-Reply-To: <20090104072706.GB12905@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christoph Hellwig =EDrta:
> On Sat, Jan 03, 2009 at 02:44:12PM +0100, Gabor Juhos wrote:
>> The AHB bus will require different code for register access, so we m=
ake
>> them replaceable as well.
>=20
> What kind of different code?  ioread*/iowrite* are supposed to be bus=
-agnostic.
>=20
>=20

I have used __raw_{read,write}*. You are right, I have tried it right n=
ow and it
works with io{read,write}* as well. I will remove them.

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
