Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23201 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab0CBHyX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 02:54:23 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 23:54:23 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19340.51368.13804.986275@gargle.gargle.HOWL>
Date: Tue, 2 Mar 2010 13:43:28 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [PATCH 1/3] ath9k_htc: Add ath9k_htc driver
In-Reply-To: <43e72e891003012343l655bacc1i57ebe9ca55262878@mail.gmail.com>
References: <19336.46643.733555.555640@gargle.gargle.HOWL>
	<20100302002759.GH8069@bombadil.infradead.org>
	<19340.37002.731064.872605@gargle.gargle.HOWL>
	<43e72e891003012343l655bacc1i57ebe9ca55262878@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> My modular approach most things were I had hope the AR6003 driver
> could also make use of the HTC/HIF framework, they would just register
> a ath9k_hif_sdio module, register itself to HTC, and use a separate
> hardware family mac80211 core driver for ar6k devices. After review of
> the current AR6003 driver architecture later on though I found out
> this was not possible, but for future mobile device I do have hope its
> possible, just as well as sharing a common ath9k_hw.

Ah ok.

But yeah, we can make it modular as we add new families/transports.

Sujith
