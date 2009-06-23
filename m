Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4000 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZFWU0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 16:26:14 -0400
Date: Tue, 23 Jun 2009 16:25:41 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: kernel crashes, 2.6.30, rt2x00, ath5k, ieee80211_get_*_rate,
	automatic rate control
Message-ID: <20090623202541.GA3635@hash.localnet>
References: <20090621134954.GA31505@linux-m68k.org> <20090621180447.GA29469@hash.localnet> <20090623174616.GA3914@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090623174616.GA3914@linux-m68k.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 23, 2009 at 07:46:16PM +0200, Richard Zidlicky wrote:
> Got the confirmation that the patch for minstrel indeed does something good
> to me, both on the ath5k and rt73usb side. The code path seems to be trigered
> only in special circumstances in my configuration but the printk did fire on
> both ends after a while.

Good news, thanks for testing.  Yeah it generally only occurs if you
have a nearby peer with a single (or none) available rates which is
why some people hit it a lot and others not so much.

The patch should already be on the way to stable, but I'll check on it.

-- 
Bob Copeland %% www.bobcopeland.com

