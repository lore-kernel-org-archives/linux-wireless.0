Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45163 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030351AbXCLPSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 11:18:01 -0400
Subject: Re: [PATCH] bcm43xx: Fix typo in B5PHY init specifications
From: David Woodhouse <dwmw2@infradead.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Joseph Jezak <josejx@gentoo.org>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20070312145309.GB8878@tuxdriver.com>
References: <45e85f2b.Dp1dM05tvZFFROmc%Larry.Finger@lwfinger.net>
	 <1173685989.3584.2.camel@shinybook.infradead.org>
	 <45F55452.3000704@gentoo.org>  <20070312145309.GB8878@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 16:16:34 +0100
Message-Id: <1173712594.3584.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-03-12 at 10:53 -0400, John W. Linville wrote:
> 
> FWIW, by inspection it looks like the mac80211-based driver is
> (trying?) to implement this change.
> 
> David, have you tried the mac80211 version?  Does it still have the
> same crash?

Should the one in 2.6.20-1.2982.fc7 be OK? I can try that relatively
easily; anything else might need to wait till I get home.

-- 
dwmw2

