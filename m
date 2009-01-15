Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19298 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbZAOI1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 03:27:50 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 00:27:50 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Message-ID: <18798.62140.234415.246664@gargle.gargle.HOWL> (sfid-20090115_092753_896747_2B740E7E)
Date: Thu, 15 Jan 2009 13:54:28 +0530
To: Gabor Juhos <juhosg@openwrt.org>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Christoph Hellwig <hch@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath9k-devel] [PATCH v4 02/11] ath9k: convert to use
 bus-agnostic DMA routines
In-Reply-To: <496EEE8B.3030702@openwrt.org>
References: <1231960632-4452-1-git-send-email-juhosg@openwrt.org>
	<1231960632-4452-3-git-send-email-juhosg@openwrt.org>
	<18798.42051.400380.269490@localhost.localdomain>
	<496EEE8B.3030702@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> Sujith  rta:
> > Gabor Juhos wrote:
> >> Convert to use bus-agnostic DMA routines to make it usable on AHB bus as well.
> >>
> >
> > This pretty much makes the previous patch redundant.
> 
> Yes. Although i can merge the two patches, but in my opinion it is easier to
> review them in this way.
> 

Alright.
Otherwise, the series looks okay to me.

Sujith
