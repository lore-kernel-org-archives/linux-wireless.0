Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34554 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab0CCDbL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 22:31:11 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 19:31:11 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19341.56441.523682.509267@gargle.gargle.HOWL>
Date: Wed, 3 Mar 2010 09:20:17 +0530
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/7] ath9k: Add common code to lib
In-Reply-To: <20100303005220.GJ8069@bombadil.infradead.org>
References: <19339.35501.467215.380773@gargle.gargle.HOWL>
	<19340.54345.580466.373621@gargle.gargle.HOWL>
	<20100303005220.GJ8069@bombadil.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Can I trouble you to repost a new series of patches required for
> ath9k_htc which does not add/use a lib.c and instead stuffs
> things into common from the start? If there are patches
> which are cosmetic, can you send them as a second series
> so that we are clear what stuff is 2.6.34-rc2 material or
> not?

I sent a mail yesterday to JWL, but forgot to CC the list.
Here is the series.

To clarify things, these are the pending patches for
ath9k_htc (in order).

[PATCH 1/3] ath9k_htc: Add ath9k_htc driver
[PATCH 2/3] ath9k_hw: HW fixes for ath9k_htc
[PATCH 3/3] ath9k: Fix HW deinit

[PATCH 1/2] ath9k: Fix symbol collision between ath9k and ath9k_htc
[PATCH 2/2] ath9k_htc: Remove library

Sujith
