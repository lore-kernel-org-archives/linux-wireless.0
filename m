Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37346 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbXI2SJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 14:09:18 -0400
Subject: Re: [PATCH] b43: Use input-polldev for the rfkill switch
From: David Woodhouse <dwmw2@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200709291932.57924.mb@bu3sch.de>
References: <200709281422.34434.mb@bu3sch.de>
	 <200709291908.24758.mb@bu3sch.de>
	 <1191086074.8203.18.camel@shinybook.infradead.org>
	 <200709291932.57924.mb@bu3sch.de>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 19:09:11 +0100
Message-Id: <1191089351.2911.0.camel@shinybook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-09-29 at 19:32 +0200, Michael Buesch wrote:
> The patch is correct as-is. RF-kill was polled by the periodic work.

OK, cool. Just checking.

-- 
dwmw2

