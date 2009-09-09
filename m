Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3715 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbZIITcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 15:32:51 -0400
Date: Wed, 9 Sep 2009 15:31:40 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	lrodriguez@atheros.com, mickflemm@gmail.com, jirislaby@gmail.com,
	linville@tuxdriver.com, johannes@sipsolutions.net
Subject: Re: [PATCH] ath5k: do not free irq after resume when card has been
	removed
Message-ID: <20090909193140.GA17717@hash.localnet>
References: <1252457551-4909-1-git-send-email-cascardo@holoscopio.com> <20090909033237.GC13550@hash.localnet> <20090909175006.GA7945@vespa.holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090909175006.GA7945@vespa.holoscopio.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 09, 2009 at 02:50:06PM -0300, Thadeu Lima de Souza Cascardo wrote:
> This is against v2.6.31-rc9, so I get a warning with a version that's
> about to get stable. Sorry I am late in the release cycle.

Ok yes, that makes sense then.

> Since this is warning, is this worth backporting to rc?

It's too late probably, but we can send it to stable for 2.6.31.1.

Thank you for the patch by the way, just keep in mind that wireless
patches should be against the wireless-testing kernel in the future.

-- 
Bob Copeland %% www.bobcopeland.com

