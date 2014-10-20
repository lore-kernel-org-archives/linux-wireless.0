Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36147 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbaJTJaq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 05:30:46 -0400
Message-ID: <1413797433.10246.2.camel@jlt4.sipsolutions.net> (sfid-20141020_113049_767211_EA45D584)
Subject: Re: [PATCH v2 23/23] ath9k: Do not start BA when scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Date: Mon, 20 Oct 2014 11:30:33 +0200
In-Reply-To: <1413511830-5536-24-git-send-email-sujith@msujith.org> (sfid-20141017_041320_989836_D8611F04)
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
	 <1413511830-5536-24-git-send-email-sujith@msujith.org>
	 (sfid-20141017_041320_989836_D8611F04)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-17 at 07:40 +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> mac80211 currently has a race which can be hit
> with this sequence:

If it's a mac80211 race, wouldn't it make sense to fix it in mac80211?

johannes

