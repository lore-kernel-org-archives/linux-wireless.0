Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab3BDPjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:39:11 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U2O8U-0002zb-7s
	for linux-wireless@vger.kernel.org; Mon, 04 Feb 2013 16:39:10 +0100
Message-ID: <1359992375.10311.18.camel@jlt4.sipsolutions.net> (sfid-20130204_163927_562806_F618572D)
Subject: Re: [PATCH v2] cfg80211: simplify mesh BSS comparison
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2013 16:39:35 +0100
In-Reply-To: <1359532464-25555-1-git-send-email-johannes@sipsolutions.net> (sfid-20130130_085427_341396_725C3C25)
References: <1359532464-25555-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130130_085427_341396_725C3C25)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-30 at 08:54 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Instead of first checking if a BSS is an MBSS
> and then doing the comparisons, inline it all
> into the BSS comparison function. This avoids
> doing the IE searches twice and is also a lot
> less code.

Applied.

johannes

