Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab1IGTNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 15:13:53 -0400
Subject: Re: [PATCH IGNORE AT YOUR PERIL] cfg80211: force interface
 combinations to be advertised
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1315412512.4002.10.camel@jlt3.sipsolutions.net> (sfid-20110907_182203_669205_5D3FA4B3)
References: <1315412512.4002.10.camel@jlt3.sipsolutions.net>
	 (sfid-20110907_182203_669205_5D3FA4B3)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Sep 2011 21:13:52 +0200
Message-ID: <1315422832.4002.19.camel@jlt3.sipsolutions.net> (sfid-20110907_211356_464224_93F8B1DD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Actually, I'll retract this patch.

I'm working on actually making use of this information in wpa_s, at
which point everybody will want it anyway, or so I hope ;-)

johannes

