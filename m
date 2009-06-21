Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4085 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZFUSFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2009 14:05:22 -0400
Date: Sun, 21 Jun 2009 14:04:47 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: kernel crashes, 2.6.30, rt2x00, ath5k, ieee80211_get_*_rate,
	automatic rate control
Message-ID: <20090621180447.GA29469@hash.localnet>
References: <20090621134954.GA31505@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090621134954.GA31505@linux-m68k.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 21, 2009 at 03:49:54PM +0200, Richard Zidlicky wrote:
> 
> The good news - setting a fixed rate appears to prevent all crashes. This is
> perhaps the reason why wireless developers never see this crashes?

Sounds like the rate controller.  Does this patch help?

http://lkml.org/lkml/2009/6/5/269

-- 
Bob Copeland %% www.bobcopeland.com

