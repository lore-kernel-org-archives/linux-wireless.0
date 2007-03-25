Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34403 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbXCYQxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2007 12:53:52 -0400
Subject: Re: [PATCH] bcm43xx: Fix machine check on PPC for version 1 PHY
From: David Woodhouse <dwmw2@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
In-Reply-To: <200703251613.23880.mb@bu3sch.de>
References: <46067d12.1uF8l72xIYAG6Vyb%Larry.Finger@lwfinger.net>
	 <200703251613.23880.mb@bu3sch.de>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 17:53:48 +0100
Message-Id: <1174841628.20505.244.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-03-25 at 16:13 +0200, Michael Buesch wrote:
> I'm not sure this patch is complete.
> Joseph made changes to the specs that should fix the issue completely.
> I didn't look at the changes, yet. 

I don't see relevant changes in the v3 specs. I was working empirically,
reverting parts of the large patch which broke it.

-- 
dwmw2

