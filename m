Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:51586 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab2GIN0A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 09:26:00 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH] Fix oops when set_monitor_enabled() not defined in the struct cfg80211_ops
References: <1341745690-12574-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1341745890.4987.6.camel@jlt3.sipsolutions.net>
Date: Mon, 09 Jul 2012 16:25:57 +0300
In-Reply-To: <1341745890.4987.6.camel@jlt3.sipsolutions.net> (Johannes Berg's
	message of "Sun, 08 Jul 2012 13:11:30 +0200")
Message-ID: <87liit2hi2.fsf@purkki.adurom.net> (sfid-20120709_152603_424322_0424983F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sun, 2012-07-08 at 14:08 +0300, Vladimir Kondratiev wrote:
>> Quick fix for method being invoked without checking its existence
>> 
>> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

[...]

>
> Oh, good catch, applied

Title is missing "cfg80211: " prefix. Is it too late to change that?

-- 
Kalle Valo
