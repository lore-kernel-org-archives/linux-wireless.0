Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canuck.infradead.org ([209.217.80.40]:48526 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbXDPAG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2007 20:06:56 -0400
Subject: Re: [PATCH] bcm43xx-mac80211: Fix machine checks on PPC with rev   1 PHYs
From: David Woodhouse <dwmw2@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Bcm43xx-dev@lists.berlios.de
In-Reply-To: <1176477466.7052.114.camel@johannes.berg>
References: <461d0815.ip3FDr8RDQXyCT4U%Larry.Finger@lwfinger.net>
	 <20070413113638.10db9767@localhost>  <461F9C58.6050106@lwfinger.net>
	 <1176477466.7052.114.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 01:06:38 +0100
Message-Id: <1176681998.7929.81.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-04-13 at 17:17 +0200, Johannes Berg wrote:
> With phy rev == 1, the gmode bit is assumed unset when initialising a
> G PHY. Maybe that is the crucial difference. David will send me some
> backtraces of this problem, once he does I'll look at it again.

http://david.woodhou.se/bcm43xx-mac80211.dmesg-3.txt 

The module itself is at http://david.woodhou.se/bcm43xx-mac80211.ko so
you can find line numbers where they're not immediately obvious.

-- 
dwmw2

