Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:43011 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753409Ab2E1G0z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 02:26:55 -0400
Message-ID: <1338186413.2202.16.camel@joe2Laptop> (sfid-20120528_082658_553419_87C96277)
Subject: Re: [RFC] mac80211: net_ratelimit few aggregation related messages
From: Joe Perches <joe@perches.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Sun, 27 May 2012 23:26:53 -0700
In-Reply-To: <4FC3180F.1060902@qca.qualcomm.com>
References: <1337960224-7428-1-git-send-email-mohammed@qca.qualcomm.com>
	 <1337976166.30100.6.camel@joe2Laptop> <4FC3180F.1060902@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 11:45 +0530, Mohammed Shafi Shajakhan wrote:
> just today saw this link where you had introduced net_dbg_ratelimited
> http://www.digipedia.pl/usenet/thread/18978/31017/
> so should i send the v2 patch using net_dbg_ratelimited to net-next 
> rather than wireless-testing tree ?

Yes, but you should wait until net-next opens
for patches (after Linus' -rc1 is released)


