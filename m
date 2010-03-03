Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57354 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758583Ab0CCAwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 19:52:21 -0500
Date: Tue, 2 Mar 2010 19:52:20 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/7] ath9k: Add common code to lib
Message-ID: <20100303005220.GJ8069@bombadil.infradead.org>
References: <19339.35501.467215.380773@gargle.gargle.HOWL> <19340.54345.580466.373621@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19340.54345.580466.373621@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 02, 2010 at 02:33:05PM +0530, Sujith wrote:
> John,
> 
> Can you drop this series (7/7) ?
> We had a bit of confusion regarding sharing code between
> ath9k and ath9k_htc. And it has been decided to just use
> ath9k_common.ko.
> 
> Sorry for the trouble.

Sujith, I myself am a bit confused with the patches which
I should apply locally to get a clean history and move on with
development on ath9k.

Can I trouble you to repost a new series of patches required for
ath9k_htc which does not add/use a lib.c and instead stuffs
things into common from the start? If there are patches
which are cosmetic, can you send them as a second series
so that we are clear what stuff is 2.6.34-rc2 material or
not?

  Luis
