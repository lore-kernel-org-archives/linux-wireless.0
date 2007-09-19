Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42992
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbXISNvB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 09:51:01 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] softmac: Fix inability to associate with WEP networks, and the inability to change essid
Date: Wed, 19 Sep 2007 15:48:20 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <46f090e4.wi04CrQ11sG6gLcC%Larry.Finger@lwfinger.net>
In-Reply-To: <46f090e4.wi04CrQ11sG6gLcC%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709191548.20528.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 19 September 2007 05:00:52 Larry Finger wrote:
> Commit 4cf92a3c was submitted as a fix for bug #8686 at bugzilla.kernel.org
> (http://bugzilla.kernel.org/show_bug.cgi?id=8686). Unfortunately, the fix led to
> a new bug, reported by Yoshifuji Hideaki, that prevented association for WEP
> encrypted networks that use ifconfig to control the device. This patch effectively
> reverts the earlier commit and does a proper fix for bug #8686.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This fix replaces my earlier request for reversion of commit 4cf92a3c. As stated
> above, it effectively does the reversion, but it also fixes the original bug.

Looks good and might be OK. Though, I won't ack this, as I don't really
understand the statemachine. So if it works and fixes both bugs, please merge
this into mainline and (more important) into -stable.

-- 
Greetings Michael.
