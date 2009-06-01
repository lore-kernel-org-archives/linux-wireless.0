Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3727 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbZFAAdp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 20:33:45 -0400
Date: Sun, 31 May 2009 20:32:09 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] Crda oopses the system
Message-ID: <20090601003209.GA3917@hash.localnet>
References: <1242258469.3241.19.camel@maxim-laptop> <43e72e890905131707k2933f3cftfdec6e632f5b9fc3@mail.gmail.com> <b6c5339f0905140720p29be483cr1968f50a6bea48e5@mail.gmail.com> <1242742647.23110.10.camel@ibm172> <1242951611.5206.9.camel@maxim-laptop> <43e72e890905211736i3dfaf7d5q78d511eac0fbca1e@mail.gmail.com> <1242986902.5544.8.camel@maxim-laptop> <20090531062217.GB23972@bombadil.infradead.org> <1243774031.5741.5.camel@maxim-laptop> <1243803253.5417.12.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243803253.5417.12.camel@maxim-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 31, 2009 at 11:54:13PM +0300, Maxim Levitsky wrote:
> 2 - ath5k makes kernel panic, reliably after few times hostapd have
> started, I didn't yet captured the output.
> I remember to see panics with ad-hoc as well. 
> I mean blinking leds on keyboard.

This should be fixed at least with a patch I recently posted to
linux-wireless.

> 3 - couldn't transfer any frames between AP and client, only association
> works.

Yeah I still plan to fix it, just haven't found cycles for it yet.

-- 
Bob Copeland %% www.bobcopeland.com

