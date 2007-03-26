Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60466 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbXCZMNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 08:13:31 -0400
Subject: Re: [PATCH] bcm43xx: Fix machine check on PPC for version 1 PHY
From: David Woodhouse <dwmw2@infradead.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de
In-Reply-To: <460730FF.1050603@lwfinger.net>
References: <46067d12.1uF8l72xIYAG6Vyb%Larry.Finger@lwfinger.net>
	 <200703251613.23880.mb@bu3sch.de>  <460730FF.1050603@lwfinger.net>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 13:13:22 +0100
Message-Id: <1174911202.3238.15.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-03-25 at 21:33 -0500, Larry Finger wrote:
> Joseph has fixed the problem in initb5 (the first hunk), but the second hunk is still not in the new
> specs. It was in the previous version in a slightly different form, but was found largely by trial
> and error.
> 
> I would prefer that this patch go forward as is so that we don't end up with this bug in the
> released version of 21.6.21. I am in the process of making the initg code match the current specs,
> but that will certainly require more testing than I think we have time to complete before 2.6.21 is
> released. 

FWIW I tried the mac80211 version (with v4 firmware) and saw very
similar machine checks, even after trying to apply the same 'fixes'.

-- 
dwmw2

