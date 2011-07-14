Return-path: <kvalo@adurom.com>
Received: from purkki.adurom.net ([80.68.90.206]:33606 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab1GNKGq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 06:06:46 -0400
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: reconfigure tx on device reconfiguration
References: <1310628070-6012-1-git-send-email-eliad@wizery.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 14 Jul 2011 13:06:41 +0300
In-Reply-To: <1310628070-6012-1-git-send-email-eliad@wizery.com> (Eliad Peller's message of "Thu\, 14 Jul 2011 10\:21\:10 +0300")
Message-ID: <87mxghw4zy.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eliad Peller <eliad@wizery.com> writes:

> Add tx_conf array to save the current tx queues
> configuration, and reconfig it on resume (ieee80211_reconfig).

Why? You could describe a bit in the commit log what real (or user
visible) issue this patch fixes. I can guess but usually my guesses
are wrong ;)

-- 
Kalle Valo
